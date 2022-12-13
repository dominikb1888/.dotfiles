#!/usr/bin/env python3
# License: GPL v3 Copyright: 2018, Kovid Goyal <kovid at kovidgoyal.net>

import concurrent
import os
import re
from concurrent.futures import ProcessPoolExecutor
from typing import (
    IO, Dict, Iterable, Iterator, List, Optional, Tuple, Union, cast
)

from pygments import highlight  # type: ignore
from pygments.formatter import Formatter  # type: ignore
from pygments.lexers import get_lexer_for_filename  # type: ignore
from pygments.util import ClassNotFound  # type: ignore

from kitty.multiprocessing import get_process_pool_executor
from kitty.rgb import color_as_sgr, parse_sharp

from .collect import Collection, Segment, data_for_path, lines_for_path


class StyleNotFound(Exception):
    pass


class DiffFormatter(Formatter):  # type: ignore

    def __init__(self, style: str = 'default') -> None:
        try:
            Formatter.__init__(self, style=style)
            initialized = True
        except ClassNotFound:
            initialized = False
        if not initialized:
            raise StyleNotFound(f'pygments style "{style}" not found')

        self.styles: Dict[str, Tuple[str, str]] = {}
        for token, token_style in self.style:
            start = []
            end = []
            fstart = fend = ''
            # a style item is a tuple in the following form:
            # colors are readily specified in hex: 'RRGGBB'
            col = token_style['color']
            if col:
                pc = parse_sharp(col)
                if pc is not None:
                    start.append('38' + color_as_sgr(pc))
                    end.append('39')
            if token_style['bold']:
                start.append('1')
                end.append('22')
            if token_style['italic']:
                start.append('3')
                end.append('23')
            if token_style['underline']:
                start.append('4')
                end.append('24')
            if start:
                fstart = '\033[{}m'.format(';'.join(start))
                fend = '\033[{}m'.format(';'.join(end))
            self.styles[token] = fstart, fend

    def format(self, tokensource: Iterable[Tuple[str, str]], outfile: IO[str]) -> None:
        for ttype, value in tokensource:
            not_found = True
            if value.rstrip('\n'):
                while ttype and not_found:
                    tok = self.styles.get(ttype)
                    if tok is None:
                        ttype = ttype[:-1]
                    else:
                        on, off = tok
                        lines = value.split('\n')
                        for line in lines:
                            if line:
                                outfile.write(on + line + off)
                            if line is not lines[-1]:
                                outfile.write('\n')
                        not_found = False

            if not_found:
                outfile.write(value)


formatter: Optional[DiffFormatter] = None


def initialize_highlighter(style: str = 'default') -> None:
    global formatter
    formatter = DiffFormatter(style)


def highlight_data(code: str, filename: str, aliases: Optional[Dict[str, str]] = None) -> Optional[str]:
    if aliases:
        base, ext = os.path.splitext(filename)
        alias = aliases.get(ext[1:])
        if alias is not None:
            filename = f'{base}.{alias}'
    try:
        lexer = get_lexer_for_filename(filename, stripnl=False)
    except ClassNotFound:
        return None
    return cast(str, highlight(code, lexer, formatter))


split_pat = re.compile(r'(\033\[.*?m)')


def highlight_line(line: str) -> List[Segment]:
    ans: List[Segment] = []
    current: Optional[Segment] = None
    pos = 0
    for x in split_pat.split(line):
        if x.startswith('\033'):
            if current is None:
                current = Segment(pos, x)
            else:
                current.end = pos
                current.end_code = x
                ans.append(current)
                current = None
        else:
            pos += len(x)
    return ans


DiffHighlight = List[List[Segment]]


def highlight_for_diff(path: str, aliases: Dict[str, str]) -> DiffHighlight:
    ans: DiffHighlight = []
    lines = lines_for_path(path)
    hd = highlight_data('\n'.join(lines), path, aliases)
    if hd is not None:
        for line in hd.splitlines():
            ans.append(highlight_line(line))
    return ans


process_pool_executor: Optional[ProcessPoolExecutor] = None


def get_highlight_processes() -> Iterator[int]:
    if process_pool_executor is None:
        return
    for pid in process_pool_executor._processes:
        yield pid


def highlight_collection(collection: Collection, aliases: Optional[Dict[str, str]] = None) -> Union[str, Dict[str, DiffHighlight]]:
    global process_pool_executor
    jobs = {}
    ans: Dict[str, DiffHighlight] = {}
    with get_process_pool_executor(prefer_fork=True) as executor:
        process_pool_executor = executor
        for path, item_type, other_path in collection:
            if item_type != 'rename':
                for p in (path, other_path):
                    if p:
                        is_binary = isinstance(data_for_path(p), bytes)
                        if not is_binary:
                            jobs[executor.submit(highlight_for_diff, p, aliases or {})] = p
        for future in concurrent.futures.as_completed(jobs):
            path = jobs[future]
            try:
                highlights = future.result()
            except Exception as e:
                import traceback
                tb = traceback.format_exc()
                return f'Running syntax highlighting for {path} generated an exception: {e} with traceback:\n{tb}'
            ans[path] = highlights
    return ans


def main() -> None:
    # kitty +runpy "from kittens.diff.highlight import main; main()" file
    import sys

    from .options.types import defaults
    initialize_highlighter()
    with open(sys.argv[-1]) as f:
        highlighted = highlight_data(f.read(), f.name, defaults.syntax_aliases)
    if highlighted is None:
        raise SystemExit(f'Unknown filetype: {sys.argv[-1]}')
    print(highlighted)
