.. program:: ghdl

.. _COSIM:VHPIDIRECT:Wrapping:

.. _Starting_a_simulation_from_a_foreign_program:

Wrapping a simulation (ghdl_main)
=================================

You may run your design from an external program. You just have to call
the ``ghdl_main`` function which can be defined:

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
  Don't forget to list the object file(s) of this entry point and other foreign sources, as per :ref:`Linking_with_foreign_object_files`.

.. ATTENTION::
  The ``ghdl_main`` function must be called once, since reseting/restarting the simulation runtime is not supported yet. A workaround is to build the simulation as a shared object and load the ``ghdl_main`` symbol from it (see :ref:`COSIM:VHPIDIRECT:Examples:shared:shghdl`).

.. HINT::
  Immitating the run time flags, such as ``-gDEPTH=12`` from :option:`-gGENERIC`, requires the ``argv`` to have the executable's path at index 0, effectively shifting all other indicies along by 1. This can be taken from the 0 index of the ``argv`` passed to ``main()``, or (not suggested, despite a lack of consequences) left empty/null.

  Since ``ghdl_main`` is the entrypoint to the design (GRT runtime), the supported CLI options are the ones shown in :ref:`USING:Simulation`. Options for analysis/elaboration are not required and will NOT work. See :option:`-r`.
