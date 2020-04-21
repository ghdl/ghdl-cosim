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

.. _COSIM:VHPIDIRECT:Examples:arrays:logicvectors:

:cosimtree:`logicvector <vhpidirect/arrays/logicvector>`
**************************************************************

Commonly signals in VHDL are of a logic type or a vector thereof (``std_logic`` and ``std_logic_vector``), coming from IEEE's ``std_logic_1164`` package.
These types can hold values other than high and low (``1`` and ``0``) and are enumerated as:

0. 'U'
1. 'X'
2. '0'
3. '1'
4. 'Z'
5. 'W'
6. 'L'
7. 'H'
8. '-'

As mentioned in :ref:`Restrictions_on_foreign_declarations`:

	- Because the number of enumeration values is less than 256, logic values are transported in 8 bit words (a ``char`` type in C).

		- In this example two declarations make handling logic values in C a bit easier:

			- Providing logic values in C as their enumeration numbers is simplified with the use of a matching enumeration, ``HDL_LOGIC_STATES``.
			- Printing out a logic value's associated character is also simplified with the ``const char HDL_LOGIC_CHAR[]`` declaration.

	- Logic vectors, of a bounded size, can be easily created in C as a ``char[]`` and passed to VHDL to be read as an ``access`` type in VHDL, in this case an access of a subtype of std_logic_vector.


This example builds on the integer vector example (:ref:`COSIM:VHPIDIRECT:Examples:arrays:intvector`), by instead passing an array of logic values. Foreign subprograms are declared that enable receiving the size of two different logic vectors as well as the vectors themselves from C. There is only one subprogram to get the size of both C arrays, and it takes in an integer to determine which array's size gets returned.

.. HINT::
  The ``getLogicVecSize`` in VHDL is declared as receiving a ``boolean`` argument. In C the function is declared to receive an ``char`` argument. The VHDL booleans ``false`` and ``true`` are enumerations, and have integer values, ``0`` and ``1`` respectively. As with the logic values, the boolean enumerations use fewer than 8 bits, so the single byte in C's ``char`` variable receives the VHDL enumeration correctly.

For illustrative purposes, the two vectors are populated with logic values in different ways:

- LogicVectorA's indices are manually filled with enumeration values from HDL_LOGIC_STATES.

  - .. code-block:: C

        logic_vec_A[0] = HDL_U;

- LogicVectorB's indices are filled with an integer value.

  - .. code-block:: C

        for(int i = 0; i < SIZE_LOGIC_VEC_B; i++){
          logic_vec_B[i] = 8-i;
        }

.. ATTENTION::
  The integer values that are given to ``char`` variables in C which are intended to be read as VHDL logic values, must be limited to [0, 8]. This ensures that they represent one of the 9 enumerated logic values.
