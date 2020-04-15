.. program:: ghdl

.. _COSIM:VHPIDIRECT:Dynamic:

Dynamic loading
###############

Building either foreign resources or the VHDL simulation model as shared libraries allows to decouple the build procedures.

.. _COSIM:VHPIDIRECT:Dynamic:loading_within_a_simulation:

Loading foreign objects from within a simulation
================================================

Instead of linking and building foreign objects along with GHDL, it is also possible to load foreign resources dynamically.
In order to do so, provide the path and name of the shared library where the resource is to be loaded from. For example:

.. code-block:: VHDL

  attribute foreign of get_rand: function is "VHPIDIRECT ./getrand.so get_rand";

.. _COSIM:VHPIDIRECT:Dynamic:generating_shared_libraries:

Generating shared libraries
===========================

.. TIP::
  Ensure reading and understanding :ref:`COSIM:VHPIDIRECT:Linking` before this one.

There are three possibilities to elaborate simulation models as shared libraries, instead of executable binaries:

* ``ghdl -e -shared [options...] primary_unit [secondary_unit]``

* ``ghdl -e -Wl,-shared -Wl,-Wl,--version-script=./file.ver -Wl,-Wl,-u,ghdl_main [options...] primary_unit [secondary_unit]``

* ``gcc -shared -Wl,`ghdl --list-link tb` -Wl,--version-script=./file.ver -Wl,-u,ghdl_main``

The only difference between the two later procedures is the entrypoint (GHDL or GCC). Preference depends on the additional options that users need to provide. The main difference with the former is that it will make all symbols visible in the resulting shared library. In the other two procedures, visible symbols will be the ones defined in the default ``grt.ver`` added by GHDL and the ``file.ver`` provided by the user. Note that ``file.ver`` must include ``ghdl_main`` and any other added by the user. See example :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl` and :cosimsharp:`2`.

.. HINT::
  When GHDL is configured with ``--default-pic`` explicitly, it uses it implicitly when executing any :option:`-a`, :option:`-e` or :option:`-r` command. Hence, it is not required to provide these arguments (fPIC/PIE) to GHDL. However, these might need to be provided when building C sources with GCC. Otherwise linker errors such as the following are produced:

  .. code-block::

    relocation R_X86_64_PC32 against symbol * can not be used when making a shared object; recompile with -fPIC

.. HINT::
  For further details regarding how to call ``ghdl_main`` see :ref:`Starting_a_simulation_from_a_foreign_program`.

.. NOTE::
  Alternatively, if the shared library is built with :option:`--bind` and :option:`--list-link`, the output from the later can be filtered with tools such as ``sed`` in order to remove the default version script (accomplished in :ghdlsharp:`640`), and make all symbols visible by default. However, this procedure is only recommended in edge cases where other solutions don't fit.

.. _COSIM:VHPIDIRECT:Dynamic:loading_a_simulation:

Loading a simulation
====================

.. ATTENTION::
  By default, GHDL uses ``grt.ver`` to limit which symbols are exposed in the generated artifacts, and ``ghdl_main`` is not included. See :ref:`COSIM:VHPIDIRECT:Dynamic:generating_shared_libraries` for guidelines to generate shared objects with visible or filtered symbols.

In order to generate a position independent executable (PIE), be it an executable binary
or a shared library, GHDL must be built with config option ``--default-pic``. This will ensure
that all the libraries and sources analyzed by GHDL generate position independent code (PIC).

PIE binaries can be loaded and executed from any language that supports C-alike signatures and types
(C, C++, golang, Python, Rust, etc.). This allows seamless co-simulation using concurrent/parallel execution features available in each language:
pthreads, goroutines/gochannels, multiprocessing/queues, etc. Moreover, it provides a mechanism to execute multiple
GHDL simulations in parallel.

For example, in Python:

.. code-block:: Python

  import ctypes
  gbin = ctypes.CDLL(bin_path)

  args = ['-gGENA="value"', 'gGENB="value"']

  xargs = (ctypes.POINTER(ctypes.c_char) * (len(args) + 1))()
  for i, arg in enumerate(args):
      xargs[i] = ctypes.create_string_buffer(arg.encode('utf-8'))
  return args[0], xargs

  gbin.main(len(xargv)-1, xargv)

  import _ctypes
  # On GNU/Linux
  _ctypes.dlclose(gbin._handle)
  # On Windows
  #_ctypes.FreeLibrary(gbin._handle)

See a complete example written in C in :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl`.

.. TIP::
  As explained in :ref:`Starting_a_simulation_from_a_foreign_program`, ``ghdl_main`` must be called once, since reseting/restarting the simulation runtime is not supported yet (see :ghdlsharp:`1184`). When it is loaded dynamically, this means that the binary file/library needs to be unloaded from memory and loaded again (as in :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl`).

.. TIP::
  See :ghdlsharp:`803` for details about expected differences in the exit codes, depending on the version of the VHDL standard that is used.
