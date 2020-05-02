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

Instead of using GHDL's own entrypoint to the execution, it is possible to wrap it by providing a custom ``main``
function. Upon existence of ``main``, execution of the simulation is triggered by calling ``ghdl_main``.

This is the most basic example of such usage. ``ghdl_main`` is declared as ``extern`` in C, and arguments ``argc`` and
``argv`` are passed without modification. However, this sets the ground for custom prepocessing and postprocessing in a
foreign language.

Other options are to just pass empty arguments (``ghdl_main(0, NULL)``) or to customize them:

.. code-block:: C

  char* args[] = {NULL, "--wave=wave.ghw"};
  ghdl_main(2, args);

See :ref:`COSIM:VHPIDIRECT:Wrapping` for further details about the constraints of ``argv``.

:cosimtree:`time <vhpidirect/quickstart/wrapping/time>`
-------------------------------------------------------

Although most of the provided examples are written in C, VHPIDIRECT can be used with any language that supports a
C-alike compile and link model.

This example shows how to time the execution of a simulation from either C or Ada. In both cases, function ``clock`` is
used to get the time before and after calling ``ghdl_main``. Regarding the build procedure, it is to be noted that C
sources are elaborated with :option:`-e`, because GHDL allows to pass parameters (in this case, additional C sources)
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

This example shows multiple alternatives to share variables through packages, depending on the target version of the
standard. Three different binaries are built from the same entity, using:

  * A VHDL 1993 package with ``--std=93``.

  * A VHDL 1993 package with ``--std=08 -frelaxed``.

  * A VHDL 2008 package with ``--std=08``.

.. NOTE::
  Procedure ``setVar`` is not strictly required. It is used to allow the same descriptions of the entity/architectures
  to work with both VHDL 1993 and VHDL 2008. See the bodies of the procedure in :cosimtree:`pkg_93.vhd <vhpidirect/quickstart/sharedvar/pkg_93.vhd>` and :cosimtree:`pkg_08.vhd <vhpidirect/quickstart/sharedvar/pkg_08.vhd>`.

As an alternative to using a shared variable in VHDL, subdir :cosimtree:`shint <vhpidirect/quickstart/sharedvar/shint>`
contains an approach based on a helper record type which is used as a handle. Mimicking the concept of *methods* from
Object Oriented (OO) programming, helper C functions are used to read/write the actual variables, instead of sharing
data through an access/pointer. This approach is more verbose than others, but it works with either VHDL 1993 or VHDL
2008 without modification and without requiring :option:`-frelaxed`. Moreover, it enhances encapsulation, as it provides
a user-defined API between VHDL and C, which can improve maintainability when sources are reused. As a matter of fact,
this approach is found in verification projects such as `VUnit <http://vunit.github.io/>`_ and `OSVVM <https://osvvm.org/>`_.
