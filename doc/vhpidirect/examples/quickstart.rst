.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:quickstart:

Quick Start
###########

.. _COSIM:VHPIDIRECT:Examples:quickstart:random:

:cosimtree:`'rand' from stdlib <vhpidirect/quickstart/random>`
**************************************************************

By default, GHDL includes the standard C library in the generated simulation models. Hence, resources from ``stdlib``
can be used without any modification to the build procedure.

This example shows how to import and use ``rand`` to generate and print 10 integer numbers. The VHDL code is equivalent
to the following C snippet. However, note that this C source is NOT required, because ``stdlib`` is already built in.

.. code-block:: C

    #include <stdlib.h>
    #include <stdio.h>

    int main (void) {
      int i;
      for (i = 0; i < 10; i++)
        printf ("%d\n", rand ());
      return 0;
    }

.. _COSIM:VHPIDIRECT:Examples:quickstart:math:

:cosimtree:`'sin' from libmath <vhpidirect/quickstart/math>`
************************************************************

By the same token, it is possible to include functions from system library by just providing the corresponding linker
flag.

In this example, function ``sin`` from the ``math`` library is used to compute 10 values. As in the previous example,
no additional C sources are required, because the ``math`` library is already compiled and installed in the system.

.. _COSIM:VHPIDIRECT:Examples:quickstart:customc:

:cosimtree:`custom C <vhpidirect/quickstart/customc>`
*****************************************************

When the required functionality is not available in pre-built libraries, custom C sources and/or objects can be added
to the elaboration and/or linking.

This example shows how to bind custom C functions in VHDL as either procedures or functions. Four cases are included:
``custom_procedure``, ``custom_procedure_withargs``, ``custom_function`` and ``custom_function_withargs``. In all
cases, the parameters are defined as integers, in order to keep it simple. See :ref:`COSIM:VHPIDIRECT:Declarations`
for further details.

Since either C sources or pre-compiled ``.o`` objects can be added, in C/C++ projects of moderate complexity, it might
be desirable to merge all the C sources in a single object before elaborating the design.

.. _COSIM:VHPIDIRECT:Examples:wrapping:

Wrapping ghdl_main
******************

.. _COSIM:VHPIDIRECT:Examples:quickstart:wrapping:basic:

:cosimtree:`basic <vhpidirect/quickstart/wrapping/basic>`
---------------------------------------------------------

Instead of using GHDL's own entrypoint to the execution, it is possible to wrap it by providing a custom program
entrypoint (``main`` function), wherein the execution of the simulation is triggered by calling ``ghdl_main``.

This example shows the most basic of such usage. ``ghdl_main`` is declared as ``extern`` in C, and arguments ``argc``
and ``argv`` are passed without modification. However, this sets the ground for custom prepocessing and postprocessing
in a foreign language.

Other options are to just pass empty arguments (``ghdl_main(0, NULL)``) or to customize them:

.. code-block:: C

  char* args[] = {NULL, "--wave=wave.ghw"};
  ghdl_main(2, args);

See :ref:`COSIM:VHPIDIRECT:Wrapping` for further details about the constraints of ``argv``. Furthermore, section
:ref:`COSIM:VHPIDIRECT:Examples:quickstart:cli` below shows argument parsing/manipulation strategies.

:cosimtree:`time <vhpidirect/quickstart/wrapping/time>`
-------------------------------------------------------

Although most of the provided examples are written in C, VHPIDIRECT can be used with any language that supports a
C-like compile and link model.

This example shows how to time the execution of a simulation from either C or Ada. In both cases, function ``clock`` is
used to get the time before and after calling ``ghdl_main``. Regarding the build procedure, it is to be noted that C
sources are elaborated with :option:`-e`, because GHDL allows passing parameters (in this case, additional C sources)
to the compiler and/or linker. However, since it is not possible to do so with Ada, ``gnatmake``, :option:`--bind` and
:option:`--list-link` are used instead. See :ref:`COSIM:VHPIDIRECT:Linking` for further info about custom linking setups.

.. HINT::
  Compared to the previous example, the declaration of ``ghdl_main`` includes three arguments in this example:
  ``int argc, void** argv, void** envp``. This is done for illustration purposes only, as it has no real effect on the
  exercise.

.. _COSIM:VHPIDIRECT:Examples:quickstart:linking:

Linking
*******

:cosimtree:`bind <vhpidirect/quickstart/linking/bind>`
------------------------------------------------------

Although GHDL's elaborate command can compile and link C sources, it is sometimes preferred or required to call a
compiler explicitly with custom arguments. This is useful, e.g., when a simulation is to be embedded in the build of an
existing C/C++ application.

This example is equivalent to :ref:`COSIM:VHPIDIRECT:Examples:quickstart:wrapping:basic`, but it shows how to use
:option:`--bind` and :option:`--list-link` instead of :option:`-e`. See :ref:`COSIM:VHPIDIRECT:Linking` for further
details.

.. HINT::
  Objects generated by :option:`--bind` are created in the working directory. See :ref:`gccllvm-only-programs` and
  :ghdlsharp:`781`.


.. _COSIM:VHPIDIRECT:Examples:quickstart:package:

:cosimtree:`package <vhpidirect/quickstart/package>`
****************************************************

If the auxillary VHPIDIRECT subprograms need to be accessed in more than one entity, it is possible to package the
subprograms. This also makes it very easy to reuse the VHPIDIRECT declarations in different projects.

In this example two different entities use a C defined ``c_printInt(val: integer)`` subprogram to print two different
numbers. Subprogram declaration requirements are detailed under the :ref:`COSIM:VHPIDIRECT:Declarations` section.

.. _COSIM:VHPIDIRECT:Examples:quickstart:sharedvar:

:cosimtree:`sharedvar <vhpidirect/quickstart/sharedvar>`
********************************************************

While sharing variables through packages in VHDL 1993 is flexible, in VHDL 2008 protected types need to be used.
However, GHDL allows to relax some rules of the LRM through :option:`-frelaxed`.

This example showcases multiple ways of sharing variables through packages, depending on the target version of the
standard. Three different binaries are built from the same entity, using:

* A VHDL 1993 package with ``--std=93``.
* A VHDL 1993 package with ``--std=08 -frelaxed``.
* A VHDL 2008 package with ``--std=08``.

.. NOTE::
  Procedure ``setVar`` is not strictly required. It is used to allow the same descriptions of the entity/architectures
  to work with both VHDL 1993 and VHDL 2008. See the bodies of the procedure in :cosimtree:`pkg_93.vhd <vhpidirect/quickstart/sharedvar/pkg_93.vhd>` and :cosimtree:`pkg_08.vhd <vhpidirect/quickstart/sharedvar/pkg_08.vhd>`.

.. _COSIM:VHPIDIRECT:Examples:quickstart:shint:

:cosimtree:`shint <vhpidirect/quickstart/sharedvar/shint>`
-------------------------------------------------------------

As an alternative to using a shared variable in VHDL, subdir :cosimtree:`shint <vhpidirect/quickstart/sharedvar/shint>`
contains an approach based on a helper record type which is used as a handle. Mimicking the concept of *methods* from
Object Oriented (OO) programming, helper C functions are used to read/write the actual variables, instead of sharing
data through an access/pointer. This approach is more verbose than others, but it works with either VHDL 1993 or VHDL
2008 without modification and without requiring :option:`-frelaxed`. Moreover, it enhances encapsulation, as it provides
a user-defined API between VHDL and C, which can improve maintainability when sources are reused. As a matter of fact,
this approach is found in verification projects such as `VUnit <http://vunit.github.io/>`_ and `OSVVM <https://osvvm.org/>`_.

.. _COSIM:VHPIDIRECT:Examples:quickstart:shrecord:

:cosimtree:`shrecord <vhpidirect/quickstart/sharedvar/shrecord>`
----------------------------------------------------------------

Records are contiguous collections of types in VHDL, analogous to ``struct`` in C. This subexample quickly showcases:

 - sharing a C declared struct between VHDL entities
 - sharing a VHDL declared record with C functions

This example only uses two subprograms, and does not have a globally shared variable like the other *sharedvar* examples.
This is in order to keep the package compatible with both VHDL 93 and 08, and keep the focus on sharing a record variable.

.. NOTE::
  The records/structs have a field of type `std_logic_vector`/`char[]`, which is a variable that is more complicated than
  the integer's in previous examples. The :ref:`COSIM:VHPIDIRECT:Examples:arrays:logicvectors` example fully explains this
  variable.

As mentioned in :ref:`Restrictions_on_foreign_declarations`, records are passed by reference. This means that the functions
in C receive and return ``struct *``. In VHDL, the VHPIDIRECT subprograms will return record access types, while those with
record arguments should not be record access types (as the record is passed by reference to the linked C function).

.. NOTE::
  There is an asymmetry: records from VHDL passed to C are passed by reference, whereas structs from C passed to VHDL are
  passed by value (so C must pass a ``struct*``, which is handed over by value). To further spell out the consequences:
  VHPIDIRECT subprograms take records as their arguments but return record access types.

.. _COSIM:VHPIDIRECT:Examples:quickstart:cli:

:cosimtree:`Command-Line Arguments <vhpidirect/quickstart/cli>`
***************************************************************

Top-level generics
------------------

As explained in :ref:`simulation_options`, there is no standard method in VHDL to obtain command-line arguments. However,
GHDL allows to override top-level generics, with certain restrictions. See :option:`-gGENERIC` and :ghdlsharp:`1388` for
further details.

In this example, two top-level generics of types ``string`` and ``integer`` are used. First, default values are
used. Then, both are overriden through CLI arguments. Note that top-level generics cannot be undefined; hence, the user must
provide either default values or CLI arguments.

Parsing/customizing ``argv``
----------------------------

By the same token, when wrapping a simulation, ``ghdl_main`` receives ``argc``, ``argv`` and ``env`` as any regular
``main`` function in C. Hence, when GHDL is wrapped as explained in :ref:`Starting_a_simulation_from_a_foreign_program`,
it is possible to either pass raw arguments or to process them before calling ``ghdl_main``. As a result, overrides for
top-level generics can be defined in C sources. Otherwise, GHDL will complain by producing an error.

These examples showcase multiple approaches to manipulate top-level generics when GHDL is wrapped:

* :cosimtree:`rawargs <vhpidirect/quickstart/cli/rawargs.c>`: pass arguments without modification. This, which is equivalent
  to :ref:`COSIM:VHPIDIRECT:Examples:quickstart:wrapping:basic` above, is the minimal requirement for default CLI features
  to be available when wrapping GHDL.
* :cosimtree:`procargs <vhpidirect/quickstart/cli/procargs.c>`: pass arguments and set/add some. First, no argument is
  provided and ``genStr`` is assigned a value in C. Then, ``genInt`` is provided and ``genStr`` is added in C.

  .. NOTE::
    This is a naive approach without any specific library. `getopt <https://www.gnu.org/software/libc/manual/html_node/Getopt.html>`_
    and/or `Argp <https://www.gnu.org/software/libc/manual/html_node/Argp.html>`_ are popular ways to parse arguments
    in C. A complete example that uses *getopt* or *Argp* would be very welcome, since it would allow non trivial arguments
    (``[c options] -- [ghdl options]`` or ``[ghdl options] -- [c options]``). Feel free to `open a PR <https://github.com/ghdl/ghdl-cosim/compare>`_!

* :cosimtree:`fcnargs <vhpidirect/quickstart/cli/fcnargs/>`: pass arguments without modification, but use a function call
  to set the default of top-level generics. That is, when no arguments are provided, the value defined in C is used. However,
  when ``-ggenInt=`` is provided, it overrides the value of the top-level generic.

:cosimtree:`Setting parameters in C through VHDL generics <vhpidirect/quickstart/cli/fcngen>`
---------------------------------------------------------------------------------------------

This example is the opposite of ``fcnargs``. A VHDL generic is passed to C when calling an external subprogram. Although
this might feel as a rare use case, it is common when adapting designs that are not aware of VHPIDIRECT features, to
enhance them with external snippets/libraries in a testbench.

JSON-for-VHDL
-------------

`JSON-for-VHDL <https://github.com/Paebbels/JSON-for-VHDL>`_ is a synthesizable VHDL library that allows to provide
configuration parameters through either a JSON file or an stringified (and optionally base16 encoded) top-level generic.
Together with `jq <https://stedolan.github.io/jq/>`_ or the libraries available for almost any language, it is a very
powerful resource to pass large amounts of params with minimal maintenance effort.

Examples are available at `Paebbels/JSON-for-VHDL:tests <https://github.com/Paebbels/JSON-for-VHDL/tree/master/tests>`_.
