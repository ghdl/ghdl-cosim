from pathlib import Path
import ctypes
import _ctypes


def dlopen(path):
    if not Path(path).exists():
        print('Executable binary not found: ' + path)
        exit(1)
    try:
        return ctypes.CDLL(path)
    except OSError:
        print('Loading executables dynamically seems not to be supported on this platform')
        exit(1)


def dlclose(obj):
    _ctypes.dlclose(obj._handle)


def enc_args(args):
    xargs = (ctypes.POINTER(ctypes.c_char) * len(args))()
    for idx, arg in enumerate(args):
        xargs[idx] = ctypes.create_string_buffer(arg.encode('utf-8'))
    return xargs

def run(path, argc, argv):
    print("PY RUN ENTER")
    ghdl = dlopen(path)
    ghdl.main(argc, argv)
    # FIXME With VHDL 93, the execution is Aborted and Python exits here

    dlclose(ghdl)

    print("PY RUN EXIT")
