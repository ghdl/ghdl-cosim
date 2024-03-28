.. program:: ghdl

.. _COSIM:VHPIDIRECT:Wrapping:

.. _Starting_a_simulation_from_a_foreign_program:

Wrapping a simulation
#####################

By default, GHDL generates an internal ``main`` function, which is the entrypoint to executable binaries/simulations. However,
simulation can be optionally executed from external programs, by declaring given functions as externally defined resources. Should
an alternative ``main`` function be defined, that will be used by the executable, instead of the one from GHDL.

Wrapping the simulation allows dynamically generating test data, and/or manipulating CLI arguments.

.. ATTENTION::
  Shared libraries should not contain a ``main`` symbol, but explicitly named entrypoints. When :ref:`COSIM:VHPIDIRECT:Dynamic:generating_shared_libraries`
  or :ref:`COSIM:VHPIDIRECT:Dynamic:loading_a_simulation`, wrapping ``ghdl_main`` is required.

Single function exection (ghdl_main)
====================================

Function ``ghdl_main`` allows executing the simulation until termination. When called, GRT takes control and drives the simulation,
without intervention from the wrapper. However, if VHPIDIRECT or VPI functions/callbacks were registered, those are triggered
at the corresponding simulation time.

In your foreign sources, define the external prototype of ``ghdl_main`` as follows:

in C:

.. code-block:: C

  extern int ghdl_main (int argc, char **argv);

in Ada:

.. code-block:: Ada

  with System;
  ...
  function Ghdl_Main (Argc : Integer; Argv : System.Address)
    return Integer;
  pragma import (C, Ghdl_Main, "ghdl_main");

.. TIP::
  Don't forget to list the object file(s) of this entry point and other foreign sources, as per
  :ref:`Linking_with_foreign_object_files`.

.. ATTENTION::
  The ``ghdl_main`` function must be called once, since reseting/restarting the simulation runtime is not supported yet. A
  workaround is to build the simulation as a shared object and load the ``ghdl_main`` symbol from it (see :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl`).

.. HINT::
  Immitating the run time flags, such as ``-gDEPTH=12`` from :option:`-gGENERIC`, requires the ``argv`` to have the
  executable's path at index 0, effectively shifting all other indicies along by 1. This can be taken from the 0 index of the
  ``argv`` passed to ``main()``, or (not suggested, despite a lack of consequences) left empty/null.

  Since ``ghdl_main`` is the entrypoint to the design (the simulation kernel/runtime named GRT), the supported CLI options
  are the ones shown in :ref:`USING:Simulation`. Options for analysis/elaboration are not required and will NOT work. See :option:`-r`.

.. _COSIM:VHPIDIRECT:Wrapping:Step:

Step by step execution
======================

For finer grained control of the simulation steps, a set of lower level functions can be used instead of ``ghdl_main``.
Those are provided in :cosimtree:`grt.h <vhpidirect/grt/grt.h>`. After initializing GRT, providing arguments and initializing
the simulation, a loop allows checking the return value of each step:

.. code-block:: C

  // 0: delta cycle
  // 1: non-delta cycle
  // 2: stop
  // 3: finished
  // 4: stop-time reached
  // 5: stop-delta reached
  int ecode;
  do {
    ecode = __ghdl_simulation_step ();
    printf("ecode: %d\n", ecode);
  } while (ecode<3);
