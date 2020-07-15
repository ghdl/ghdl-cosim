entity tb is
end entity tb;

architecture arch of tb is

begin

	process

		function c_intArrSize return integer is-- represented C-side with int
		begin report "VHPIDIRECT c_intArrSize" severity failure; end;
		attribute foreign of c_intArrSize : function is "VHPIDIRECT getIntArrSize";

		type int_arr is array(0 to c_intArrSize-1) of integer;

		procedure c_intArr_p (arr: int_arr) is -- represented C-side with int*
		begin report "VHPIDIRECT c_intArr_p" severity failure; end;
		attribute foreign of c_intArr_p : procedure is "VHPIDIRECT getIntArr";

		variable c_intArr : int_arr;

	begin

		c_intArr_p(c_intArr);

		report "Array length: " & integer'image(c_intArr'length);

		for i in 0 to c_intArr'right loop
			report
				"c_intArr[" & integer'image(i) & "] = " &
				integer'image(c_intArr(i)) &
				". Set to: " &
				integer'image(-2*c_intArr(i));
			c_intArr(i) := -2*c_intArr(i);
		end loop;

		wait;
	end process;

end architecture;
