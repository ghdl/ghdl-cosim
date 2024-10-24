.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:shared:

Shared libs and dynamic loading
###############################

.. IMPORTANT::
  As explained in :ref:`COSIM:VHPIDIRECT:Dynamic:loading_a_simulation`, in order to load binaries/libraries dynamically,
  those need to be built as position independent code/executables (PIC/PIE).

This set of examples is an introduction from scratch for users who are familiar with C, but who have never built or loaded
shared libraries (``*.so``, ``*.dll`` or ``*.dyn``):

* :ref:`COSIM:VHPIDIRECT:Examples:shared:shlib`: write C code and compile it as a shared library.
* :ref:`COSIM:VHPIDIRECT:Examples:shared:dlopen`: write two shared libraries in C, and write a main C program for loading and executing both of them.
* :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl`: build a simulation as a shared library, and write a main C program for loading and executing it.
* :ref:`COSIM:VHPIDIRECT:Examples:shared:py`: build a simulation as a shared library, and write a Python script for loading and executing it.
* :ref:`COSIM:VHPIDIRECT:Examples:shared:pycb`: build a simulation as a shared library, and write a Python script for loading it and replacing callbacks
  through ``ctypes`` before executing the simulation.

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

.. _COSIM:VHPIDIRECT:Examples:shared:py:

:cosimtree:`py <vhpidirect/shared/py>`
**************************************

`Python <https://www.python.org/>`_'s :py:mod:`ctypes` module is a built-in "*foreign function library for Python*", which
"*provides C compatible data types, and allows calling functions in DLLs or shared libraries*". Thus, it is posible to
reproduce :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl` by loading and executing the simulation from Python, instead of
C.

This example uses the testbench and C sources from :ref:`COSIM:VHPIDIRECT:Examples:quickstart:wrapping:exitcb`, but the simulation
is built as a shared library and loaded dynamically from Python. A helper Python module is used for providing OS agnostic
utilities (see :cosimtree:`pyaux.py <vhpidirect/shared/py/pyaux.py>`).

.. WARNING::
  On some Linux environments, failing simulations that are dynamically loaded from Python do produce an *Abortion*. This
  forces the wrapper/caller to exit inmediately, without running any post-check. See :ghdlsharp:`803` and :cosimsharp:`15` for
  further details.

:cosimtree:`py/vunit <vhpidirect/shared/py/vunit>`
==================================================

This is equivalent to the previous example (:ref:`COSIM:VHPIDIRECT:Examples:shared:py`). Instead of calling GHDL's CLI explicitly,
VUnit's Python aided plumbing is used. This allows including any of VUnit's VHDL features into the simulation models, which
are then to be loaded dynamically from Python. In fact, this is the foundation of `VUnit/cosim <https://github.com/VUnit/cosim>`_.

.. WARNING::
  On some Linux environments, using VHDL 2008 works but VHDL 1993 does not return cleanly in case of failure. An *Abortion* is
  produced, which prevents the regular after-simulation execution of VUnit. See :ghdlsharp:`803` and :cosimsharp:`15` for
  further details.

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
  In `dbhi/vboard: VGA test pattern <https://github.com/dbhi/vboard/tree/main/vga>`_, this example and :ref:`COSIM:VHPIDIRECT:Examples:arrays:matrices:vga`
  are combined for providing a *virtual VGA screen* using Python's `NumPy <https://numpy.org/>`_, `Pillow <https://python-pillow.org/>`_
  and `Tkinter <https://docs.python.org/3/library/tkinter.html>`_.
  Equivalent solutions can be implemented using Python libraries such as `matplotlib <https://matplotlib.org/>`_,
  `panda3d <https://www.panda3d.org/>`_, `pygame <https://www.pygame.org>`_, `cocos2dpy <http://cocos2d.org/#cocos2dpy>`_, `pyglet <http://pyglet.org/>`_, etc.
  Do you want to take up the challenge? `Propose a PR <https://github.com/ghdl/ghdl-cosim/compare>`_!
