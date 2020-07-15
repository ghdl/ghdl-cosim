library ieee;
use ieee.std_logic_1164.all;

entity tb is
end;

architecture arch of tb is
begin

	process

		constant logicArray: std_logic_vector(0 to 8) := ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-');

		function getLogicVecSize(returnSizeOfA: boolean) return integer is
		begin report "VHPIDIRECT getLogicVecSize" severity failure; end;
		attribute foreign of getLogicVecSize : function is "VHPIDIRECT getLogicVecSize";

		-- Vector A

		subtype logicVecA_t is std_logic_vector(0 to getLogicVecSize(true)-1);
		type logicVecA_ptr_t is access logicVecA_t;

		impure function getLogicVecA return logicVecA_ptr_t is
		begin report "VHPIDIRECT getLogicVecA" severity failure; end;
		attribute foreign of getLogicVecA : function is "VHPIDIRECT getLogicVecA";

		variable logicVecA: logicVecA_ptr_t := getLogicVecA;

		-- Vector B

		constant vecB_len : natural := getLogicVecSize(false);

		procedure getLogicVecB (vec: std_ulogic_vector(0 to vecB_len-1)) is
		begin report "VHPIDIRECT getLogicVecB" severity failure; end;
		attribute foreign of getLogicVecB : procedure is "VHPIDIRECT getLogicVecB";

		variable logicVecB: std_ulogic_vector(0 to vecB_len-1);

	begin

		getLogicVecB(logicVecB);

		report "logicVecA'length: " & integer'image(logicVecA'length) severity note;

		for x in logicVecA'range loop
			report "Asserting VecA [" & integer'image(x) & "]: " & std_logic'image(logicVecA(x)) severity note;
			assert logicVecA(x) = logicArray(x) severity failure;
		end loop;

		report "logicVecB'length: " & integer'image(logicVecB'length) severity note;

		for x in logicVecB'range loop
			report "Asserting VecB [" & integer'image(x) & "]: " & std_logic'image(logicVecB(x)) severity note;
			assert logicVecB(x) = logicArray(8-x) severity failure;
		end loop;

		wait;
	end process;
end;
