import sys
from sys import platform
from pathlib import Path
import ctypes
import _ctypes  # type: ignore


FUNCTYPE = ctypes.WINFUNCTYPE if platform == 'win32' else ctypes.CFUNCTYPE

def dlopen(path):
    """
    Open/load a PIE binary or a shared library.
    """
    if not Path(path).is_file():
        print("Executable binary not found: " + path)
        sys.exit(1)
    try:
        return ctypes.CDLL(path)
    except OSError:
        print(
            "Loading executables dynamically seems not to be supported on this platform"
        )
        sys.exit(1)


def dlclose(obj):
    """
    Close/unload a PIE binary or a shared library.
    :param obj: object returned by ctypes.CDLL when the resource was loaded
    """
    if platform == "win32":
        _ctypes.FreeLibrary(obj._handle)  # pylint:disable=protected-access,no-member
    else:
        _ctypes.dlclose(obj._handle)  # pylint:disable=protected-access,no-member


def enc_args(args):
    """
    Convert args to a suitable format for a foreign C function.
    :param args: list of strings
    """
    C_ARGS = (ctypes.POINTER(ctypes.c_char) * len(args))()
    for idx, arg in enumerate(args):
        C_ARGS[idx] = ctypes.create_string_buffer(arg.encode("utf-8"))
    return C_ARGS
