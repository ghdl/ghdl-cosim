.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:shared:

Shared libs and dynamic loading
###############################

.. IMPORTANT::
  As explained in :ref:`COSIM:VHPIDIRECT:Dynamic:loading_a_simulation`, in order to load binaries/libraries dynamically,
  those need to be built as position independent code/executables (PIC/PIE).

.. _COSIM:VHPIDIRECT:Examples:shared:shlib:

:cosimtree:`shlib <vhpidirect/shared/shlib>`
********************************************

This example features the same functionality as :ref:`COSIM:VHPIDIRECT:Examples:quickstart:random`. However, custom C
sources are used (as in :ref:`COSIM:VHPIDIRECT:Examples:quickstart:customc`) and these are built as a shared library.
See :ref:`COSIM:VHPIDIRECT:Dynamic:loading_within_a_simulation` for further info.

.. _COSIM:VHPIDIRECT:Examples:shared:dlopen:

:cosimtree:`dlopen <vhpidirect/shared/dlopen>`
**********************************************

Although this example does not include a simulation built with GHDL, it is a test and the introduction to the next
example. In this test, two separate shared libraries are built from C sources, both including a function named
``ghdl_main``. Then, in a main C application, both shared libraries are dynamically loaded at the same time, and both
are executed (one after the other).

This example tests whether symbol ``ghdl_main`` is visible in the shared libraries, and whether the same symbol name
can be loaded from multiple shared libraries (and used) at the same time.

.. TIP::
  If the symbol is not found, try adding `-g`, `-rdynamic` and/or `-O0` when building the shared libraries. Tools such
  as ``objdump``, ``readelf`` or ``nm`` can be used to check if a symbol is visible. For instance, ``objdump -d corea.so | grep ghdl_main``.

.. HINT::
  Building multiple designs as separate artifacts and dynamically loading them at the same time is a naive approach to
  multi-core simulation with GHDL. It is also a possible solution for coarse grained co-simulation with Verilator.

.. _COSIM:VHPIDIRECT:Examples:shared:shghdl:

:cosimtree:`shghdl <vhpidirect/shared/shghdl>`
**********************************************

This example is complementary to :ref:`COSIM:VHPIDIRECT:Examples:shared:shlib`, since the VHDL simulation is built as a
shared library, which is then loaded from a main C application (as in :ref:`COSIM:VHPIDIRECT:Examples:shared:dlopen`).

When ``main`` is executed:

* The shared libray is loaded, symbol ``print_something`` is searched for, and it is executed.
* Symbol ``ghdl_main`` is searched for, and it is executed three times. Unfortunately, GHDL does not currently support
  reseting/restarting the simulation runtime. Hence, in this example the shared library is unloaded and loaded again
  before calling ``ghdl_main`` after the first time.

See :ref:`COSIM:VHPIDIRECT:Dynamic:generating_shared_libraries` for further details with regard to the visibility of
symbols in the shared libraries.

.. NOTE::
  On GNU/linux, both executable binaries and shared libraries use the ELF format. As a result, although hackish, it is
  possible to load an executable binary dynamically, i.e. without using any of the ``shared`` options explained in
  :ref:`COSIM:VHPIDIRECT:Dynamic:generating_shared_libraries`. In this example, this case is also tested. However, this
  is not suggested at all, since it won't work on all platforms.

.. WARNING::
  Currently, failing simulations that are dynamically loaded do produce an *Abortion*. This forces any C or Python
  wrapper/caller to exit inmediately, without running any post-check. See :ghdlsharp:`803` and :cosimsharp:`15` for
  further details.

.. _COSIM:VHPIDIRECT:Examples:shared:py:

py
**

`Python <https://www.python.org/>`_'s :py:mod:`ctypes` module is a built-in "*foreign function library for Python*", which
"*provides C compatible data types, and allows calling functions in DLLs or shared libraries*". Thus, it is posible to
reproduce :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl` by loading and executing the simulation from Python, instead of
C. In fact, this is the foundation of `VUnit/cosim <https://github.com/VUnit/cosim>`_.

Nonethless, this example has not been added yet because of :cosimsharp:`15`. As soon as GHDL is fixed so that both successful
and failing simulations exit cleanly, a minimal Python example will be added here.

.. _COSIM:VHPIDIRECT:Examples:shared:pycb:

:cosimtree:`pycb <vhpidirect/shared/pycb>`
******************************************

.. ATTENTION::
  This example is conceptually built on top of :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl` and :ref:`COSIM:VHPIDIRECT:Examples:shared:py`;
  so it is strongly suggested to carefully read those first. Since Pyhon and :py:mod:`ctypes` are used, a good understanding of
  the underlaying C syntax and semantics is required.

The main purpose of this example is to showcase how to execute an arbitrary Python function from a VHDL testbench, by calling
it as a regular VHDL procedure/function and passing (complex) parameters from the VHDL domain. Precisely, function ``plot(x,y)``
from :mod:`matplotlib.pyplot` is used to draw ``x,y`` graphs from constrained arrays of integers in VHDL. The scheme is as
follows:

* A **function prototype is defined in C**. This is the definition that will be *common* to C, VHDL and Python. The prototype
  in this example is ``(int* x, int* y, int l)``, i.e. two pointers to arrays of integers are passed, and a third argument
  tells the length.
* (optional) A default implementation of the function is written in C. This is just a placeholder/canary.
* A **function pointer variable is created**, and it is initialized to the address of the default implementation.
* The **function pointer variable is used** (dereferenced and executed) **either from C, or from VHDL through VHPIDIRECT**.
* **C/VHDL sources are built as a shared library**.
* **From Python**, an alternative implementation of the function is written. **After loading the library, but before executing
  the simulation, the function pointer variable is set** to the address of the alternative implementation.

As a result, at runtime, when VHDL calls the external function, the Python callback is executed.

.. NOTE::
  For didactic purposes, the run script in this example first uses C and Python only. I.e., arrays are initialized in C and
  plotted in Python. Then, in subdir :cosimtree:`pycb <vhpidirect/shared/pycb/pyghdl>`, arrays are initialized in a VHDL
  testbench instead.

.. TIP::
  In :ref:`COSIM:VHPIDIRECT:Examples:arrays:matrices:vga` two "virtual screen backends" are shown: writing PNG/GIF with
  ImageMagick or drawing a window with ``X11/Xlib.h``. Those are written in C, but equivalent solutions can be implemented
  using Python libraries such as `matplotlib <https://matplotlib.org/>`_, `panda3d <https://www.panda3d.org/>`_,
  `pygame <https://www.pygame.org>`_, `cocos2dpy <http://cocos2d.org/#cocos2dpy>`_, `pyglet <http://pyglet.org/>`_, etc.
  Do you want to take up the challenge? `Propose a PR <https://github.com/ghdl/ghdl-cosim/compare>`_!
