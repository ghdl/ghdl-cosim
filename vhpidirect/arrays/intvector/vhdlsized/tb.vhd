use work.pkg.all;

entity tb is
end entity;


architecture vhdlallocarr of tb is

begin

	process
		variable c_intArr : int_arr;
	begin
		report "ArraySize Interface Generic: " & integer'image(c_intArr'length);

		c_initIntArrOut(c_intArr, int_arr'length);

		for i in int_arr'range loop
			report "c_intArr[" & integer'image(i) & "]: " & integer'image(c_intArr(i));
			c_intArr(i) := -3 * c_intArr(i);
		end loop;

		c_checkAndPrintIntArrOut(c_intArr, c_intArr'length);

		wait;
	end process;

end architecture;


architecture vhdlallocacc of tb is

begin

	process
		variable c_intArr : int_arr_ptr := new int_arr;
	begin
		report "ArraySize Interface Generic: " & integer'image(int_arr'length);

		c_initIntArr(c_intArr, c_intArr'length);

		for i in int_arr'range loop
			report "c_intArr[" & integer'image(i) & "]: " & integer'image(c_intArr(i));
			c_intArr(i) := -3 * c_intArr(i);
		end loop;

		c_checkAndPrintIntArr(c_intArr, c_intArr'length);

		deallocate(c_intArr);

		wait;
	end process;

end architecture;


architecture calloc of tb is

begin

	process
		variable c_intArr : int_arr_ptr := c_allocIntArr(int_arr'length);
	begin
		report "ArraySize Interface Generic: " & integer'image(int_arr'length);

		c_initIntArr(c_intArr, c_intArr'length);

		for i in int_arr'range loop
			report "c_intArr[" & integer'image(i) & "]: " & integer'image(c_intArr(i));
			c_intArr(i) := -3 * c_intArr(i);
		end loop;

		c_checkAndPrintIntArr(c_intArr, c_intArr'length);

		c_freePointer(c_intArr);

		wait;
	end process;

end architecture;
