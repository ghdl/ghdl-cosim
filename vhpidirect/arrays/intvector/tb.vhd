entity tb is
end entity tb;

architecture RTL of tb is

begin

	process
		function c_intArrSize return integer is-- represented C-side with int
		begin
			assert false report "c_intArrSize VHPI" severity failure;
		end;
		attribute foreign of c_intArrSize : function is "VHPIDIRECT getIntArrSize"; -- getIntArrSize is the C-side function name

		type int_arr is array(0 to c_intArrSize-1) of integer;
		type int_arr_ptr is access int_arr; -- represented C-side with int*

		function c_intArr_ptr return int_arr_ptr is
		begin
			assert false report "c_intArr_ptr VHPI" severity failure;
		end;
		attribute foreign of c_intArr_ptr : function is "VHPIDIRECT getIntArr_ptr";

		variable c_intArr : int_arr_ptr := c_intArr_ptr;

	begin
		report "Array length: " & integer'image(c_intArr.all'length);

		for i in 0 to c_intArr.all'right loop
			report "c_intArr[" & integer'image(i) &"] = " &  integer'image(c_intArr.all(i)) & ". Set to: " & integer'image(-2*c_intArr.all(i));
			c_intArr.all(i) := -2*c_intArr.all(i);
		end loop;

		wait;
	end process;

end architecture RTL;
