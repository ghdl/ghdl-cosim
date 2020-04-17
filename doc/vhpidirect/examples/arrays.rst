.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:arrays:

Arrays
#######

Bounded Integer Arrays
**********************

:cosimtree:`A Bounded Array: Sized in C <vhpidirect/arrays/intvector>`
----------------------------------------------------------------------

Integer arrays fully defined in C can be passed to VHDL by first passing their size, so that an appropriate array
type can be created to hold the array's pointer. After that, a VHDL subprogram can be defined to return the array access.

:cosimtree:`A Bounded Array: Sized in C main() <vhpidirect/arrays/intvector/maindefined>`
----------------------------------------------------------------------------------------------------------

If the integer array must be created or filled by some more advanced process before VHDL can request the array's pointer, it is
possible to execute the GHDL simulation within a custom ``int main()`` entrypoint (see :ref:`COSIM:VHPIDIRECT:Examples:wrapping:basic`).
In this example the custom entrypoint prompts the user for the size of the array and then handles the variables appropriately before
going on to execute the GHDL simulation.

:cosimtree:`A Bounded Array: Sized in VHDL <vhpidirect/arrays/intvector/vhdlsized>`
----------------------------------------------------------------------------------

In order to define the size of a bounded C-side array in VHDL, the foreign C function that returns its pointer could take in the array's size as an argument. The function would allocate enough memory to the array's pointer. This means that the memory has to be freed up when VHDL is done with the array.

This example does exactly that: after allocating enough memory for the integer pointer to reference VHDL's requested number of integers, the function also initialises each index of the array (an optional step), and when the toplevel VHDL entity is about to conclude, it calls the foreign C function to release the array's allocated memory.

.. Interface generics are the generics of the toplevel VHDL entity, and their values can be set via GHDL's runtime option :option:`-g` (see :ref:`simulation_options`). In this example an interface generic is used as an argument for the call of the VHPIDIRECT subprogram ``c_intArr_ptr(arraySize: integer)``. This subprogram is linked to the foreign C function ``getIntArr_ptr(int arraySize)`` which uses the argument to allocate an ``int*`` enough space to contain ``arraySize`` integers, populating each index thereafter. The subprogram returns the array's pointer and each index is printed out in VHDL.

.. .. NOTE::
	The C function is actually extended to handle a second call. If the ``int*`` has been used before its memory is freed, and if the new arraySize is greater than 0, the pointer is allocated enough memory again. In this way, a VHDL subprogram call of ``c_intArr_ptr(0);`` frees the previously allocated memory.
