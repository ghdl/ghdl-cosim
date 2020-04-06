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

.. _COSIM:VHPIDIRECT:Dynamic:loading_a_simulation:

Loading a simulation
====================

In order to generate a position independent executable (PIE), be it an executable binary
or a shared library, GHDL must be built with config option ``--default-pic``. This will ensure
that all the libraries and sources analyzed by GHDL generate position independent code (PIC).
Furthermore, when the binary is built, argument ``-Wl,-pie`` needs to be provided.

PIE binaries can be loaded and executed from any language that supports C-alike signatures and types
(C, C++, golang, Python, Rust, etc.). For example, in Python:

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

This allows seamless co-simulation using concurrent/parallel execution features available in each language:
pthreads, goroutines/gochannels, multiprocessing/queues, etc. Moreover, it provides a mechanism to execute multiple
GHDL simulations in parallel.

.. TIP::
  As explained in :ref:`Starting_a_simulation_from_a_foreign_program`, ``ghdl_main`` must be called once, since reseting/restarting the simulation runtime is not supported yet (see :ghdlsharp:`1184`). When it is loaded dynamically, this means that the binary file/library needs to be unloaded from memory and loaded again.

.. ATTENTION::
  By default, GHDL uses ``grt.ver`` to limit which symbols are exposed in the generated binary, and ``ghdl_main`` is not included. Hence, the version script needs to be removed, or a complementary script needs to be provided. Otherwise, it will not be possible to find the function easily. See :option:`--list-link` for further info.

.. TIP::
  See :ghdlsharp:`803` for details about expected differences in the exit codes, depending on the version of the VHDL standard that is used.
