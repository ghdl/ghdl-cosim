.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:wrapping:

Wrapping
########

.. _COSIM:VHPIDIRECT:Examples:wrapping:basic:

:cosimtree:`basic <vhpidirect/wrapping/basic>`
**********************************************

Instead of using GHDL's own entrypoint to the execution, it is possible to wrap it by providing a custom ``main`` function. Upon existence of ``main``, execution of the simulation is triggered by calling ``ghdl_main``.

This is the most basic example of such usage. ``ghdl_main`` is declared as ``extern`` in C, and arguments ``argc`` and ``argv`` are passed without modification. However, this sets the ground for custom prepocessing and postprocessing in a foreign language.

Other options are to just pass empty arguments (``ghdl_main(0, NULL)``) or to customize them:

.. code-block:: C

  char* args[] = {NULL, "--wave=wave.ghw"};
  ghdl_main(2, args);

See :ref:`COSIM:VHPIDIRECT:Wrapping` for further details about the constraints of ``argv``.

:cosimtree:`time <vhpidirect/wrapping/time>`
********************************************

Although most of the provided examples are written in C, VHPIDIRECT can be used with any language that supports a C-alike compile and link model.

This example shows how to time the execution of a simulation from either C or Ada. In both cases, function ``clock`` is used to get the time before and after calling ``ghdl_main``. Regarding the build procedure, it is to be noted that C sources are elaborated with :option:`-e`, because GHDL allows to pass parameters (in this case, additional C sources) to the compiler and/or linker. However, since it is not possible to do so with Ada, ``gnatmake``, :option:`--bind` and :option:`--list-link` are used instead. See :ref:`COSIM:VHPIDIRECT:Linking` for further info about custom linking setups.

.. HINT::
  Compared to the previous example, the declaration of ``ghdl_main`` includes three arguments in this example: ``int argc, void** argv, void** envp``. This is done for illustration purposes only, as it has no real effect on the exercise.
