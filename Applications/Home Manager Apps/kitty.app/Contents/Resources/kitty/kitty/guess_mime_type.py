#!/usr/bin/env python
# License: GPLv3 Copyright: 2020, Kovid Goyal <kovid at kovidgoyal.net>

import os
import stat
from contextlib import suppress
from typing import Optional

known_extensions = {
    'asciidoc': 'text/asciidoctor',
    'conf': 'text/config',
    'md': 'text/markdown',
    'pyj': 'text/rapydscript-ng',
    'recipe': 'text/python',
    'rst': 'text/restructured-text',
    'toml': 'text/toml',
    'vim': 'text/vim',
    'yaml': 'text/yaml',
    'js': 'text/javascript',
    'json': 'text/json',
}


text_mimes = ('application/javascript', 'application/x-sh', 'application/x-shellscript', 'application/json')


def is_rc_file(path: str) -> bool:
    name = os.path.basename(path)
    return '.' not in name and name.endswith('rc')


def is_folder(path: str) -> bool:
    with suppress(OSError):
        return os.path.isdir(path)
    return False


def initialize_mime_database() -> None:
    if hasattr(initialize_mime_database, 'inited'):
        return
    setattr(initialize_mime_database, 'inited', True)
    from mimetypes import init
    init(None)
    from kitty.constants import config_dir
    local_defs = os.path.join(config_dir, 'mime.types')
    if os.path.exists(local_defs):
        init((local_defs,))


def guess_type(path: str, allow_filesystem_access: bool = False) -> Optional[str]:
    is_dir = is_exe = False

    if allow_filesystem_access:
        with suppress(OSError):
            st = os.stat(path)
            is_dir = bool(stat.S_ISDIR(st.st_mode))
            is_exe = bool(not is_dir and st.st_mode & (stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH) and os.access(path, os.X_OK))

    if is_dir:
        return 'inode/directory'
    from mimetypes import guess_type as stdlib_guess_type
    initialize_mime_database()
    mt = None
    with suppress(Exception):
        mt = stdlib_guess_type(path)[0]
    if not mt:
        ext = path.rpartition('.')[-1].lower()
        mt = known_extensions.get(ext)
    if mt in text_mimes:
        mt = f'text/{mt.split("/", 1)[-1]}'
    if not mt and is_rc_file(path):
        mt = 'text/plain'
    if not mt:
        if is_dir:
            mt = 'inode/directory'  # type: ignore
        elif is_exe:
            mt = 'inode/executable'
    return mt
