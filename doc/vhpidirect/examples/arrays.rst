.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:arrays:

Arrays
#######

Constrained/bounded integer arrays
**********************************

As explained in :ref:`Restrictions_on_foreign_declarations`, unconstrained arrays are represented by a fat pointer in C,
and it is not suggested to use fat pointers unless it is unavoidable. Hence, it is desirable for data buffers which are
to be represented as arrays to be constrained. However, constraining arrays in VHDL and C separatedly is error prone.

This example includes multiple solutions to set the bounding size once only (either in C or in VHDL), and have the
parameter passed to the other language so that matching types are defined. Moreover, independently of where is the size
defined, it is possible to allocate and free the buffers in any of the languages. The following examples show how to
define them in C or VHDL and have them (de)allocated in either of them.

.. ATTENTION::
  Pointers/accesses MUST be freed/deallocated in the same language that was used to allocate them. Hence, it is not
  possible to allocate in VHDL and free in C or *vice versa*.

:cosimtree:`Sized in C <vhpidirect/arrays/intvector/csized>`
------------------------------------------------------------

Integer arrays fully defined in C can be passed to VHDL by first passing their size, so that an appropriate array
type can be created in VHDL to hold the array's access (pointer). After that, another VHPIDIRECT subprogram can be
defined to return the array access.

This example shows how to hardcode both the length and the initial content of an array in C. Matching types are created in
VHDL, the pointer is passed and the content is read and modified from VHDL.

If the integer array must be created or filled at runtime by some more advanced process, it is possible to execute the GHDL
simulation within a custom ``main()`` entrypoint (see :ref:`COSIM:VHPIDIRECT:Examples:wrapping:basic`). This use case is
included in the example too. By using ``main.c`` instead of ``caux.c``, the content of the array is written programatically
in C, before calling ``ghdl_main``. Note that the content of the array is read from C both before and after executing the
simulation.

.. NOTE::
  There is no explicit example about how to have the size defined in C, but have the allocation/deallocation performed
  in VHDL. However, implementing such a solution is a matter of combining these examples with the VHDL-sized ones below.

:cosimtree:`Sized in VHDL <vhpidirect/arrays/intvector/vhdlsized>`
------------------------------------------------------------------

Complementing the examples above, when the size of a bounded/constrained array is defined in VHDL, it is possible to have
the (de)allocation performed in either VHDL or C. However, while accesses to constrained VHDL types do contain metada about
the bounds, pointers in C do not. Hence, in these examples, the length is explicitly passed along with the pointer/access.
Note that other possible implementations would save the length in a variable in C, so that it does not need to be passed
each time. This is done in the example with ``main()`` above.

In this example two equivalent architectures are provided. In ``calloc`` allocation and deallocation is done in C, invoked
from VHDL. Conversely, in ``vhdlalloc`` the allocation and deallocation is done in VHDL. Apart from that, both are
functionally equivalent:

* A constrained array is allocated.
* The content is initialized from C.
* The content is read and modified from VHDL.
* A function in C is used to assert the modifications and to print the results.
* The array is deallocated.

Note that VHPIDIRECT resources are defined in a package (as shown in :ref:`COSIM:VHPIDIRECT:Examples:quickstart:package`).
The same package and the corresponding C source file (``caux.c``) are used in both examples, even though ``vhdlalloc`` does
not need neither ``[c_]allocIntArr`` nor ``[c_]freePointer``.
