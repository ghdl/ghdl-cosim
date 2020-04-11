.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:quickstart:

Quick Start
###########

.. _COSIM:VHPIDIRECT:Examples:quickstart:random:

:cosimtree:`random <vhpidirect/quickstart/random>`
**************************************************

By default, GHDL includes the standard C library in the generated simulation models. Hence, resources from ``stdlib`` can be used without any modification to the build procedure.

This example shows how to import and use ``rand`` to generate and print 10 integer numbers. The VHDL code is equivalent to the following C snippet. However, note that this C source is NOT required, because ``stdlib`` is already built in.

.. code-block:: C

    #include <stdlib.h>
    #include <stdio.h>

    int main (void) {
      int i;
      for (i = 0; i < 10; i++)
        printf ("%d\n", rand ());
      return 0;
    }

:cosimtree:`math <vhpidirect/quickstart/math>`
**********************************************

By the same token, it is possible to include functions from system library by just providing the corresponding linker flag.

In this example, function ``sin`` from the ``math`` library is used to compute 10 values. As in the previous example, no additional C sources are required, because the ``math`` library is already compiled and installed in the system.

.. _COSIM:VHPIDIRECT:Examples:quickstart:customc:

:cosimtree:`customc <vhpidirect/quickstart/customc>`
****************************************************

When the required functionality is not available in pre-built libraries, custom C sources and/or objects can be added to the elaboration and/or linking.

This example shows how to bind custom C functions in VHDL as either procedures or functions. Four cases are included: ``custom_procedure``, ``custom_procedure_withargs``, ``custom_function`` and ``custom_function_withargs``. In all cases, the parameters are defined as integers, in order to keep it simple. See :ref:`COSIM:VHPIDIRECT:Declarations` for further details.

Since either C sources or pre-compiled ``.o`` objects can be added, in C/C++ projects of moderate complexity, it might be desirable to merge all the C sources in a single object before elaborating the design.
