package pkg is
	type int_arr is array(0 to 4) of integer; -- The length is defined here
	type int_arr_ptr is access int_arr; -- represented C-side with int*

	-- Procedures with argument of type int_arr

	procedure c_initIntArrOut (ptr: int_arr; arraySize: integer );
	attribute foreign of c_initIntArrOut : procedure is "VHPIDIRECT initIntArr";

	procedure c_checkAndPrintIntArrOut(ptr: int_arr; arraySize: integer);
	attribute foreign of c_checkAndPrintIntArrOut : procedure is "VHPIDIRECT checkAndPrintIntArr";

	-- Procedures with argument of type int_arr_ptr

	procedure c_initIntArr (variable ptr: int_arr_ptr; arraySize: integer );
	attribute foreign of c_initIntArr : procedure is "VHPIDIRECT initIntArr";

	procedure c_checkAndPrintIntArr(variable ptr: int_arr_ptr; arraySize: integer);
	attribute foreign of c_checkAndPrintIntArr : procedure is "VHPIDIRECT checkAndPrintIntArr";

	-- Function/procedure to allocate/retrieve and deallocate/free an array in C

	impure function c_allocIntArr(arraySize: integer) return int_arr_ptr;
	attribute foreign of c_allocIntArr : function is "VHPIDIRECT allocIntArr";

	procedure c_freePointer (variable ptr: int_arr_ptr );
	attribute foreign of c_freePointer : procedure is "VHPIDIRECT freePointer";
end package pkg;

package body pkg is
	procedure c_initIntArrOut (ptr: int_arr; arraySize: integer ) is
	begin report "VHPIDIRECT c_initIntArrOut" severity failure; end;

	procedure c_checkAndPrintIntArrOut(ptr: int_arr; arraySize: integer) is
	begin report "VHPIDIRECT c_checkAndPrintIntArrOut" severity failure; end;

	procedure c_initIntArr (variable ptr: int_arr_ptr; arraySize: integer ) is
	begin report "VHPIDIRECT c_initIntArr" severity failure; end;

	procedure c_checkAndPrintIntArr(variable ptr: int_arr_ptr; arraySize: integer) is
	begin report "VHPIDIRECT c_checkAndPrintIntArr" severity failure; end;

	impure function c_allocIntArr(arraySize: integer) return int_arr_ptr is
	begin report "VHPIDIRECT c_allocIntArr" severity failure; end;

	procedure c_freePointer (variable ptr: int_arr_ptr ) is
	begin report "VHPIDIRECT c_freePointer" severity failure; end;
end package body pkg;
