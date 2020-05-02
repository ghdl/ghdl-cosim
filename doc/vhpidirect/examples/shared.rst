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
sources are use (as in :ref:`COSIM:VHPIDIRECT:Examples:quickstart:customc`) and these are built as a shared library.
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
