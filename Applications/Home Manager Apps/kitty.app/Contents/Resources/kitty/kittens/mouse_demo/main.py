#!/usr/bin/env python
# License: GPLv3 Copyright: 2021, Kovid Goyal <kovid at kovidgoyal.net>

import sys
from typing import List, Optional

from ..show_key.kitty_mode import format_mods
from ..tui.handler import Handler
from ..tui.loop import Loop, MouseEvent
from ..tui.operations import MouseTracking


class Mouse(Handler):
    mouse_tracking = MouseTracking.full

    def __init__(self) -> None:
        self.current_mouse_event: Optional[MouseEvent] = None

    def initialize(self) -> None:
        self.cmd.set_cursor_visible(False)
        self.draw_screen()

    def finalize(self) -> None:
        self.cmd.set_cursor_visible(True)

    def on_mouse_event(self, ev: MouseEvent) -> None:
        self.current_mouse_event = ev
        self.draw_screen()

    @Handler.atomic_update
    def draw_screen(self) -> None:
        self.cmd.clear_screen()
        ev = self.current_mouse_event
        if ev is None:
            self.print('Move the mouse or click to see mouse events')
            return
        self.print(f'Position: {ev.pixel_x}, {ev.pixel_y}')
        self.print(f'Cell: {ev.cell_x}, {ev.cell_y}')
        self.print(f'{ev.type}')
        if ev.buttons:
            self.print(ev.buttons)
        if ev.mods:
            self.print(f'Modifiers: {format_mods(ev.mods)}')

    def on_interrupt(self) -> None:
        self.quit_loop(0)
    on_eot = on_interrupt


def main(args: List[str]) -> None:
    loop = Loop()
    handler = Mouse()
    loop.loop(handler)


if __name__ == '__main__':
    main(sys.argv)
