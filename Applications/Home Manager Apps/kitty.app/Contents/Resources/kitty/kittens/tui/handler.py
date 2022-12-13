#!/usr/bin/env python3
# License: GPL v3 Copyright: 2018, Kovid Goyal <kovid at kovidgoyal.net>


from collections import deque
from contextlib import suppress
from time import monotonic
from types import TracebackType
from typing import (
    TYPE_CHECKING, Any, Callable, ContextManager, Deque, Dict, NamedTuple,
    Optional, Sequence, Type, Union, cast
)

from kitty.types import DecoratedFunc, ParsedShortcut
from kitty.typing import (
    AbstractEventLoop, BossType, Debug, ImageManagerType, KeyActionType,
    KeyEventType, LoopType, MouseButton, MouseEvent, ScreenSize,
    TermManagerType
)

from .operations import MouseTracking, pending_update

if TYPE_CHECKING:
    from kitty.file_transmission import FileTransmissionCommand


class ButtonEvent(NamedTuple):
    mouse_event: MouseEvent
    timestamp: float


def is_click(a: ButtonEvent, b: ButtonEvent) -> bool:
    from .loop import EventType
    if a.mouse_event.type is not EventType.PRESS or b.mouse_event.type is not EventType.RELEASE:
        return False
    x = a.mouse_event.cell_x - b.mouse_event.cell_x
    y = a.mouse_event.cell_y - b.mouse_event.cell_y
    return x*x + y*y <= 4


class Handler:

    image_manager_class: Optional[Type[ImageManagerType]] = None
    use_alternate_screen = True
    mouse_tracking = MouseTracking.none
    terminal_io_ended = False
    overlay_ready_report_needed = False

    def _initialize(
        self,
        screen_size: ScreenSize,
        term_manager: TermManagerType,
        schedule_write: Callable[[bytes], None],
        tui_loop: LoopType,
        debug: Debug,
        image_manager: Optional[ImageManagerType] = None
    ) -> None:
        from .operations import commander
        self.screen_size = screen_size
        self._term_manager = term_manager
        self._tui_loop = tui_loop
        self._schedule_write = schedule_write
        self.debug = debug
        self.cmd = commander(self)
        self._image_manager = image_manager
        self._button_events: Dict[MouseButton, Deque[ButtonEvent]] = {}

    @property
    def image_manager(self) -> ImageManagerType:
        assert self._image_manager is not None
        return self._image_manager

    @property
    def asyncio_loop(self) -> AbstractEventLoop:
        return self._tui_loop.asyncio_loop

    def add_shortcut(self, action: KeyActionType, spec: Union[str, ParsedShortcut]) -> None:
        if not hasattr(self, '_key_shortcuts'):
            self._key_shortcuts: Dict[ParsedShortcut, KeyActionType] = {}
        if isinstance(spec, str):
            from kitty.key_encoding import parse_shortcut
            spec = parse_shortcut(spec)
        self._key_shortcuts[spec] = action

    def shortcut_action(self, key_event: KeyEventType) -> Optional[KeyActionType]:
        for sc, action in self._key_shortcuts.items():
            if key_event.matches(sc):
                return action
        return None

    def __enter__(self) -> None:
        if self._image_manager is not None:
            self._image_manager.__enter__()
        self.debug.fobj = self
        self.initialize()

    def __exit__(self, etype: type, value: Exception, tb: TracebackType) -> None:
        del self.debug.fobj
        with suppress(Exception):
            self.finalize()
            if self._image_manager is not None:
                self._image_manager.__exit__(etype, value, tb)

    def initialize(self) -> None:
        pass

    def finalize(self) -> None:
        pass

    def on_resize(self, screen_size: ScreenSize) -> None:
        self.screen_size = screen_size

    def quit_loop(self, return_code: Optional[int] = None) -> None:
        self._tui_loop.quit(return_code)

    def on_term(self) -> None:
        self._tui_loop.quit(1)

    def on_hup(self) -> None:
        self.terminal_io_ended = True
        self._tui_loop.quit(1)

    def on_key_event(self, key_event: KeyEventType, in_bracketed_paste: bool = False) -> None:
        ' Override this method and perform_default_key_action() to handle all key events '
        if key_event.text:
            self.on_text(key_event.text, in_bracketed_paste)
        else:
            self.on_key(key_event)

    def perform_default_key_action(self, key_event: KeyEventType) -> bool:
        ' Override in sub-class if you want to handle these key events yourself '
        if key_event.matches('ctrl+c'):
            self.on_interrupt()
            return True
        if key_event.matches('ctrl+d'):
            self.on_eot()
            return True
        return False

    def on_text(self, text: str, in_bracketed_paste: bool = False) -> None:
        pass

    def on_key(self, key_event: KeyEventType) -> None:
        pass

    def on_mouse_event(self, mouse_event: MouseEvent) -> None:
        from .loop import EventType
        if mouse_event.type is EventType.MOVE:
            self.on_mouse_move(mouse_event)
        elif mouse_event.type is EventType.PRESS:
            q = self._button_events.setdefault(mouse_event.buttons, deque())
            q.append(ButtonEvent(mouse_event, monotonic()))
            if len(q) > 5:
                q.popleft()
        elif mouse_event.type is EventType.RELEASE:
            q = self._button_events.setdefault(mouse_event.buttons, deque())
            q.append(ButtonEvent(mouse_event, monotonic()))
            if len(q) > 5:
                q.popleft()
            if len(q) > 1 and is_click(q[-2], q[-1]):
                self.on_click(mouse_event)

    def on_mouse_move(self, mouse_event: MouseEvent) -> None:
        pass

    def on_click(self, mouse_event: MouseEvent) -> None:
        pass

    def on_interrupt(self) -> None:
        pass

    def on_eot(self) -> None:
        pass

    def on_writing_finished(self) -> None:
        pass

    def on_kitty_cmd_response(self, response: Dict[str, Any]) -> None:
        pass

    def on_clipboard_response(self, text: str, from_primary: bool = False) -> None:
        pass

    def on_file_transfer_response(self, ftc: 'FileTransmissionCommand') -> None:
        pass

    def on_capability_response(self, name: str, val: str) -> None:
        pass

    def write(self, data: Union[bytes, str]) -> None:
        if isinstance(data, str):
            data = data.encode('utf-8')
        self._schedule_write(data)

    def flush(self) -> None:
        pass

    def print(self, *args: object, sep: str = ' ', end: str = '\r\n') -> None:
        data = sep.join(map(str, args)) + end
        self.write(data)

    def suspend(self) -> ContextManager[TermManagerType]:
        return self._term_manager.suspend()

    @classmethod
    def atomic_update(cls, func: DecoratedFunc) -> DecoratedFunc:
        from functools import wraps

        @wraps(func)
        def f(*a: Any, **kw: Any) -> Any:
            with pending_update(a[0].write):
                return func(*a, **kw)
        return cast(DecoratedFunc, f)


class HandleResult:

    type_of_input: Optional[str] = None
    no_ui: bool = False

    def __init__(self, impl: Callable[..., Any], type_of_input: Optional[str], no_ui: bool, has_ready_notification: bool):
        self.impl = impl
        self.no_ui = no_ui
        self.type_of_input = type_of_input
        self.has_ready_notification = has_ready_notification

    def __call__(self, args: Sequence[str], data: Any, target_window_id: int, boss: BossType) -> Any:
        return self.impl(args, data, target_window_id, boss)


def result_handler(
    type_of_input: Optional[str] = None,
    no_ui: bool = False,
    has_ready_notification: bool = Handler.overlay_ready_report_needed
) -> Callable[[Callable[..., Any]], HandleResult]:

    def wrapper(impl: Callable[..., Any]) -> HandleResult:
        return HandleResult(impl, type_of_input, no_ui, has_ready_notification)

    return wrapper
