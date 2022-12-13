#!/usr/bin/env python
# License: GPLv3 Copyright: 2022, Kovid Goyal <kovid at kovidgoyal.net>


import os
import sys
from typing import List


def icat(args: List[str]) -> None:
    from kittens.runner import run_kitten as rk
    sys.argv = args
    rk('icat')


def list_fonts(args: List[str]) -> None:
    from kitty.fonts.list import main as list_main
    list_main(args)


def remote_control(args: List[str]) -> None:
    from kitty.remote_control import main as rc_main
    rc_main(args)


def runpy(args: List[str]) -> None:
    if len(args) < 2:
        raise SystemExit('Usage: kitty +runpy "some python code"')
    sys.argv = ['kitty'] + args[2:]
    exec(args[1])


def hold(args: List[str]) -> None:
    import subprocess
    ret = 1
    try:
        ret = subprocess.Popen(args[1:]).wait()
    except KeyboardInterrupt:
        pass
    except FileNotFoundError:
        print(f'Could not find {args[1]!r} to execute', file=sys.stderr)
    except Exception as e:
        print(e, file=sys.stderr)
    from kitty.utils import hold_till_enter
    hold_till_enter()
    raise SystemExit(ret)


def complete(args: List[str]) -> None:
    from kitty.complete import main as complete_main
    complete_main(args[1:], entry_points, namespaced_entry_points)


def open_urls(args: List[str]) -> None:
    setattr(sys, 'cmdline_args_for_open', True)
    sys.argv = ['kitty'] + args[1:]
    from kitty.main import main as kitty_main
    kitty_main()


def launch(args: List[str]) -> None:
    import runpy
    sys.argv = args[1:]
    try:
        exe = args[1]
    except IndexError:
        raise SystemExit(
            'usage: kitty +launch script.py [arguments to be passed to script.py ...]\n\n'
            'script.py will be run with full access to kitty code. If script.py is '
            'prefixed with a : it will be searched for in PATH. If script.py is a directory '
            'the __main__.py file inside it is run just as with the normal Python interpreter.'
        )
    if exe.startswith(':'):
        import shutil
        q = shutil.which(exe[1:])
        if not q:
            raise SystemExit(f'{exe[1:]} not found in PATH')
        exe = q
    if not os.path.exists(exe):
        raise SystemExit(f'{exe} does not exist')
    runpy.run_path(exe, run_name='__main__')


def shebang(args: List[str]) -> None:
    script_path = args[1]
    cmd = args[2:]
    if cmd == ['__ext__']:
        cmd = [os.path.splitext(script_path)[1][1:].lower()]
    try:
        f = open(script_path)
    except FileNotFoundError:
        raise SystemExit(f'The file {script_path} does not exist')
    with f:
        if f.read(2) == '#!':
            line = f.readline().strip()
            _plat = sys.platform.lower()
            is_macos: bool = 'darwin' in _plat
            if is_macos:
                cmd = line.split(' ')
            else:
                cmd = line.split(' ', maxsplit=1)
    os.execvp(cmd[0], cmd + [script_path])


def run_kitten(args: List[str]) -> None:
    try:
        kitten = args[1]
    except IndexError:
        from kittens.runner import list_kittens
        list_kittens()
        raise SystemExit(1)
    sys.argv = args[1:]
    from kittens.runner import run_kitten as rk
    rk(kitten)


def edit_config_file(args: List[str]) -> None:
    from kitty.cli import create_default_opts
    from kitty.fast_data_types import set_options
    from kitty.utils import edit_config_file as f
    set_options(create_default_opts())
    f()


def namespaced(args: List[str]) -> None:
    try:
        func = namespaced_entry_points[args[1]]
    except IndexError:
        raise SystemExit('The kitty command line is incomplete')
    except KeyError:
        pass
    else:
        func(args[1:])
        return
    raise SystemExit(f'{args[1]} is not a known entry point. Choices are: ' + ', '.join(namespaced_entry_points))


entry_points = {
    # These two are here for backwards compat
    'icat': icat,
    'list-fonts': list_fonts,

    '@': remote_control,
    '+': namespaced,
}
namespaced_entry_points = {k: v for k, v in entry_points.items() if k[0] not in '+@'}
namespaced_entry_points['hold'] = hold
namespaced_entry_points['complete'] = complete
namespaced_entry_points['runpy'] = runpy
namespaced_entry_points['launch'] = launch
namespaced_entry_points['open'] = open_urls
namespaced_entry_points['kitten'] = run_kitten
namespaced_entry_points['edit-config'] = edit_config_file
namespaced_entry_points['shebang'] = shebang


def setup_openssl_environment(ext_dir: str) -> None:
    # Use our bundled CA certificates instead of the system ones, since
    # many systems come with no certificates in a useable form or have various
    # locations for the certificates.
    d = os.path.dirname
    if 'darwin' in sys.platform.lower():
        cert_file = os.path.join(d(d(d(ext_dir))), 'cacert.pem')
    else:
        cert_file = os.path.join(d(ext_dir), 'cacert.pem')
    os.environ['SSL_CERT_FILE'] = cert_file
    setattr(sys, 'kitty_ssl_env_var', 'SSL_CERT_FILE')


def main() -> None:
    if getattr(sys, 'frozen', False):
        ext_dir: str = getattr(sys, 'kitty_run_data').get('extensions_dir')
        if ext_dir:
            setup_openssl_environment(ext_dir)
    first_arg = '' if len(sys.argv) < 2 else sys.argv[1]
    func = entry_points.get(first_arg)
    if func is None:
        if first_arg.startswith('@'):
            remote_control(['@', first_arg[1:]] + sys.argv[2:])
        elif first_arg.startswith('+'):
            namespaced(['+', first_arg[1:]] + sys.argv[2:])
        else:
            from kitty.main import main as kitty_main
            kitty_main()
    else:
        func(sys.argv[1:])
