entity tb is
	generic(
		g_array_size : integer := 1
	);
end entity tb;

architecture RTL of tb is
begin
	process
		type int_arr is array(0 to g_array_size-1) of integer;
		type int_arr_ptr is access int_arr; -- represented C-side with int*

		impure function c_intArr_ptr(arraySize: integer) return int_arr_ptr is
		begin
			assert false report "c_intArr_ptr VHPI" severity failure;
		end;
		attribute foreign of c_intArr_ptr : function is "VHPIDIRECT getIntArr_ptr";

		procedure c_freePointers is
		begin
			assert false report "c_freePointers VHPI" severity failure;
		end;
		attribute foreign of c_freePointers : procedure is "VHPIDIRECT freePointers";

		variable c_intArr : int_arr_ptr := c_intArr_ptr(g_array_size);
	begin
		report "ArraySize Interface Generic: " & integer'image(g_array_size);

		for i in 0 to g_array_size-1 loop
			report "c_intArr[" & integer'image(i) & "] = " &  integer'image(c_intArr(i));
		end loop;

		c_freePointers;
		wait;
	end process;

end architecture RTL;
