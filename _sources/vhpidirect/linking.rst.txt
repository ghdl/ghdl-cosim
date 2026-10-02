.. program:: ghdl

.. _COSIM:VHPIDIRECT:Linking:

Linking object files
####################

.. _Linking_with_foreign_object_files:

Linking foreign object files to GHDL
====================================

You may add additional files or options during the link of `GHDL` using
``-Wl,`` as described in :ref:`passing-options-to-other-programs`.
For example::

  ghdl -e -Wl,-lm math_tb

will create the :file:`math_tb` executable with the :file:`lm` (mathematical)
library.

Note the :file:`c` library is always linked with an executable.

.. HINT::
  The process for personal code is the same, provided the code is provided as a C source or compiled to an object file.
  Analysis must be made of the HDL files, then elaboration with ``-e -Wl,personal.c [options...] primary_unit [secondary_unit]`` as arguments.
  Additional C or object files are flagged as separate ``-Wl,*`` arguments. The elaboration step will compile the executable with the custom resources.
  Further reading (particularly about the backend particularities) is at :ref:`Elaboration:command` and :ref:`Run:command`.

.. _Linking_with_Ada:

Linking GHDL object files to Ada/C
==================================

As explained previously in :ref:`Starting_a_simulation_from_a_foreign_program`,
you can start a simulation from an `Ada` or `C` program. However the build
process is not trivial: you have to elaborate your program and your
`VHDL` design.

.. HINT::
   If the foreign language is C, this procedure is equivalent to the one described in
   :ref:`Linking_with_foreign_object_files`, which is easier. Thus, this procedure is
   explained for didactic purposes. When suitable, we suggest to use :option:`-e`, instead
   of :option:`--bind` and :option:`--list-link`.

First, you have to analyze all your design files. In this example, we
suppose there is only one design file, :file:`design.vhdl`.

::

  $ ghdl -a design.vhdl

Then, bind your design. In this example, we suppose the entity at the
design apex is ``design``.

::

  $ ghdl --bind design

Finally, compile/bind your program and link it with your `VHDL`
design:

in C:

::

  gcc my_prog.c -Wl,`ghdl --list-link design`

in Ada:

::

  $ gnatmake my_prog -largs `ghdl --list-link design`

See :ref:`gccllvm-only-programs` for further details about :option:`--bind` and :option:`--list-link`.
