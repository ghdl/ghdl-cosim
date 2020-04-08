.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:shared:

Shared
######

.. IMPORTANT::
  As explained in :ref:`COSIM:VHPIDIRECT:Dynamic:loading_a_simulation`, in order to load binaries/libraries dynamically, those need to be built as position independent code/executables (PIC/PIE).

.. _COSIM:VHPIDIRECT:Examples:shared:shlib:

:cosimtree:`shlib <vhpidirect/shared/shlib>`
********************************************

This example features the same functionality as :ref:`COSIM:VHPIDIRECT:Examples:quickstart:random`. However, custom C sources are use (as in :ref:`COSIM:VHPIDIRECT:Examples:quickstart:customc`) and these are built as a shared library. See :ref:`COSIM:VHPIDIRECT:Dynamic:loading_within_a_simulation` for further info.

.. _COSIM:VHPIDIRECT:Examples:shared:dlopen:

:cosimtree:`dlopen <vhpidirect/shared/dlopen>`
**********************************************

Although this example does not include a simulation built with GHDL, it is a test and the introduction to the next example. In this test, two separate shared libraries are built from C sources, both including a function named ``ghdl_main``. Then, in a main C application, both shared libraries are dynamically loaded at the same time, and both are executed (one after the other)

This example tests whether symbol ``ghdl_main`` is visible in the shared libraries, and whether the same symbol name can be loaded from multiple shared libraries (and use them) at the same time.

.. TIP::
  If the symbol is not found, try adding `-g`, `-rdynamic` and/or `-O0` when building the shared libraries. Tools such as ``objdump``, ``readelf`` or ``nm`` can be used to check if a symbol is visible. For instance, ``objdump -d corea.so | grep ghdl_main``.

.. HINT::
  Building multiple designs as separate artifacts and dynamically loading them at the same time is a naive approach to multi-core simulation with GHDL. It is also a possible solution for coarse grained co-simulation with Verilator.

:cosimtree:`shghdl <vhpidirect/shared/shghdl>`
**********************************************

This example is complementary to :ref:`COSIM:VHPIDIRECT:Examples:shared:shlib`, since the VHDL simulation is built as a shared library, which is then loaded from a main C application (as in :ref:`COSIM:VHPIDIRECT:Examples:shared:dlopen`).

When ``main`` is executed, the shared libray is loaded, symbol ``ghdl_main`` is searched for, and it is executed. Unfortunately, GHL does not make ``ghdl_main`` visible by default. Hence, if a simulation model is to be loaded dynamically, visibility needs to be tweaked. This is also true for any additional function that is described in the C sources that are linked to the simulation model.

* It is possible to force a symbol to be added with ``-Wl,-Wl,-u,ghdl_main``.

* If the shared library is built with :option:`-e`, option ``-Wl,-Wl,--version-script=file.ver`` can be used, where ``file.ver`` is an additional custom version file such as:

.. code-block:: C

  VHPIDIRECT {
    global:
  ghdl_main;
    local:
  *;
  };

* [**EXPERIMENTAL** :ghdlsharp:`1184`] Alternatively, :option:`-shared` removes the version script.

* If the shared library is built with :option:`--bind` and :option:`--list-link`, the output from the later can be filtered with tools such as ``sed`` in order to remove the default version script, and make all symbols visible by default. It is also possible to pass an additional script. See description of :option:`--list-link` for further details.

.. HINT::
  When GHDL is configured with ``--default-pic`` explicitly, it uses it implicitly when executing any :option:`-a`, :option:`-e` or :option:`-r` command. Hence, it is not required to provide these arguments (fPIC/PIE) to GHDL. However, these might need to be provided when building C sources with GCC. Otherwise linker errors such as the following are produced:

  .. code-block::

    relocation R_X86_64_PC32 against symbol * can not be used when making a shared object; recompile with -fPIC
