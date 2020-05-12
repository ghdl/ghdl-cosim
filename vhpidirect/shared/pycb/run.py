from os import environ
from sys import platform
from pathlib import Path
import ctypes

import numpy as np
from matplotlib import pyplot as plt

from utils import dlopen, dlclose, enc_args, FUNCTYPE


def plotxy(x, y, l):
    print("plotxy", x, y, l)

    xx = np.ctypeslib.as_array((ctypes.c_int * l).from_address(ctypes.addressof(x.contents)))
    yy = np.ctypeslib.as_array((ctypes.c_int * l).from_address(ctypes.addressof(y.contents)))

    plt.title("ghdl-cosim Python callback example")
    plt.xlabel("x axis caption")
    plt.ylabel("y axis caption")
    plt.plot(xx,yy)
    if 'CI' not in environ:
        plt.show()


C_PLOTXY = FUNCTYPE(None, ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int), ctypes.c_int)(plotxy)

C_ARGS = enc_args([str(Path(__file__))])

CAUXDLL = dlopen("./caux.so")

print("> c_main")
print(CAUXDLL.c_main(len(C_ARGS), C_ARGS))

dlclose(CAUXDLL)
CAUXDLL = dlopen("./caux.so")

print("> pymain")
print(CAUXDLL.py_main(len(C_ARGS), C_ARGS, C_PLOTXY))
