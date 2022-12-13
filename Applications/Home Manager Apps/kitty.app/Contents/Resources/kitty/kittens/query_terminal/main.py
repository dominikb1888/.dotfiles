#!/usr/bin/env python
# License: GPLv3 Copyright: 2020, Kovid Goyal <kovid at kovidgoyal.net>

import re
import sys
from binascii import hexlify, unhexlify
from contextlib import suppress
from typing import Dict, Iterable, List, Type, Optional

from kitty.cli import parse_args
from kitty.cli_stub import QueryTerminalCLIOptions
from kitty.constants import appname, str_version
from kitty.options.types import Options
from kitty.terminfo import names
from kitty.utils import TTYIO


class Query:
    name: str = ''
    ans: str = ''
    help_text: str = ''
    override_query_name: str = ''

    @property
    def query_name(self) -> str:
        return self.override_query_name or f'kitty-query-{self.name}'

    def __init__(self) -> None:
        self.encoded_query_name = hexlify(self.query_name.encode('utf-8')).decode('ascii')
        self.pat = re.compile(f'\x1bP([01])\\+r{self.encoded_query_name}(.*?)\x1b\\\\'.encode('ascii'))

    def query_code(self) -> str:
        return f"\x1bP+q{self.encoded_query_name}\x1b\\"

    def decode_response(self, res: bytes) -> str:
        return unhexlify(res).decode('utf-8')

    def more_needed(self, buffer: bytes) -> bool:
        m = self.pat.search(buffer)
        if m is None:
            return True
        if m.group(1) == b'1':
            q = m.group(2)
            if q.startswith(b'='):
                with suppress(Exception):
                    self.ans = self.decode_response(memoryview(q)[1:])
        return False

    def output_line(self) -> str:
        return self.ans

    @staticmethod
    def get_result(opts: Options) -> str:
        raise NotImplementedError()


all_queries: Dict[str, Type[Query]] = {}


def query(cls: Type[Query]) -> Type[Query]:
    all_queries[cls.name] = cls
    return cls


@query
class TerminalName(Query):
    name: str = 'name'
    override_query_name: str = 'name'
    help_text: str = f'Terminal name (e.g. :code:`{names[0]}`)'

    @staticmethod
    def get_result(opts: Options) -> str:
        return appname


@query
class TerminalVersion(Query):
    name: str = 'version'
    help_text: str = f'Terminal version (e.g. :code:`{str_version}`)'

    @staticmethod
    def get_result(opts: Options) -> str:
        return str_version


@query
class AllowHyperlinks(Query):
    name: str = 'allow_hyperlinks'
    help_text: str = 'The config option :opt:`allow_hyperlinks` in :file:`kitty.conf` for allowing hyperlinks can be :code:`yes`, :code:`no` or :code:`ask`'

    @staticmethod
    def get_result(opts: Options) -> str:
        return 'ask' if opts.allow_hyperlinks == 0b11 else ('yes' if opts.allow_hyperlinks else 'no')


@query
class FontFamily(Query):
    name: str = 'font_family'
    help_text: str = 'The current font\'s PostScript name'

    @staticmethod
    def get_result(opts: Options) -> str:
        from kitty.fast_data_types import current_fonts
        cf = current_fonts()
        return str(cf['medium'].display_name())


@query
class BoldFont(Query):
    name: str = 'bold_font'
    help_text: str = 'The current bold font\'s PostScript name'

    @staticmethod
    def get_result(opts: Options) -> str:
        from kitty.fast_data_types import current_fonts
        cf = current_fonts()
        return str(cf['bold'].display_name())


@query
class ItalicFont(Query):
    name: str = 'italic_font'
    help_text: str = 'The current italic font\'s PostScript name'

    @staticmethod
    def get_result(opts: Options) -> str:
        from kitty.fast_data_types import current_fonts
        cf = current_fonts()
        return str(cf['italic'].display_name())


@query
class BiFont(Query):
    name: str = 'bold_italic_font'
    help_text: str = 'The current bold-italic font\'s PostScript name'

    @staticmethod
    def get_result(opts: Options) -> str:
        from kitty.fast_data_types import current_fonts
        cf = current_fonts()
        return str(cf['bi'].display_name())


@query
class FontSize(Query):
    name: str = 'font_size'
    help_text: str = 'The current overall font size (individual windows can have different per window font sizes)'

    @staticmethod
    def get_result(opts: Options) -> str:
        return f'{opts.font_size:g}'


@query
class ClipboardControl(Query):
    name: str = 'clipboard_control'
    help_text: str = 'The config option :opt:`clipboard_control` in :file:`kitty.conf` for allowing reads/writes to/from the clipboard'

    @staticmethod
    def get_result(opts: Options) -> str:
        return ' '.join(opts.clipboard_control)


def get_result(name: str) -> Optional[str]:
    from kitty.fast_data_types import get_options
    q = all_queries.get(name)
    if q is None:
        return None
    return q.get_result(get_options())


def do_queries(queries: Iterable[str], cli_opts: QueryTerminalCLIOptions) -> Dict[str, str]:
    actions = tuple(all_queries[x]() for x in queries)
    qstring = ''.join(a.query_code() for a in actions)
    received = b''
    pat = re.compile(rb'\x1b\[\?.+?c')

    def more_needed(data: bytes) -> bool:
        nonlocal received
        received += data
        has_da1_response = pat.search(received) is not None
        if has_da1_response:
            return False
        for a in actions:
            if a.more_needed(received):
                return True
        return has_da1_response

    with TTYIO() as ttyio:
        ttyio.send(qstring)
        ttyio.send('\x1b[c')  # DA1 query https://vt100.net/docs/vt510-rm/DA1.html
        ttyio.recv(more_needed, timeout=cli_opts.wait_for)

    return {a.name: a.output_line() for a in actions}


def options_spec() -> str:
    return '''\
--wait-for
type=float
default=10
The amount of time (in seconds) to wait for a response from the terminal, after
querying it.
'''


help_text = '''\
Query the terminal this kitten is run in for various capabilities. This sends
escape codes to the terminal and based on its response prints out data about
supported capabilities. Note that this is a blocking operation, since it has to
wait for a response from the terminal. You can control the maximum wait time via
the :code:`--wait-for` option.

The output is lines of the form::

    query: data

If a particular :italic:`query` is unsupported by the running kitty version, the
:italic:`data` will be blank.

Note that when calling this from another program, be very careful not to perform
any I/O on the terminal device until this kitten exits.

Available queries are:

{}

'''.format('\n'.join(
    f':code:`{name}`:\n  {c.help_text}\n' for name, c in all_queries.items()))
usage = '[query1 query2 ...]'


def main(args: List[str] = sys.argv) -> None:
    cli_opts, items_ = parse_args(
        args[1:],
        options_spec,
        usage,
        help_text,
        f'{appname} +kitten query_terminal',
        result_class=QueryTerminalCLIOptions
    )
    queries: List[str] = list(items_)
    if 'all' in queries or not queries:
        queries = sorted(all_queries)
    else:
        extra = frozenset(queries) - frozenset(all_queries)
        if extra:
            raise SystemExit(f'Unknown queries: {", ".join(extra)}')

    for key, val in do_queries(queries, cli_opts).items():
        print(f'{key}:', val)


if __name__ == '__main__':
    main()
elif __name__ == '__doc__':
    cd = sys.cli_docs  # type: ignore
    cd['usage'] = usage
    cd['options'] = options_spec
    cd['help_text'] = help_text
