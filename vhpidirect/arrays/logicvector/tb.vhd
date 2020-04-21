library ieee;
use ieee.std_logic_1164.all;

entity tb is
end;

architecture arch of tb is
begin

	process

		function getLogicVecSize(returnSizeOfA: boolean) return integer is
		begin assert false report "VHPIDIRECT getLogicVecSize" severity failure; end;
		attribute foreign of getLogicVecSize : function is "VHPIDIRECT getLogicVecSize";

		subtype logic_vec_a_t is std_logic_vector(0 to getLogicVecSize(true)-1);
		type logic_vec_a_ptr_t is access logic_vec_a_t;

		subtype logic_vec_b_t is std_ulogic_vector(0 to getLogicVecSize(false)-1);
		type logic_vec_b_ptr_t is access logic_vec_b_t;

		function getLogicVecA return logic_vec_a_ptr_t is
		begin assert false report "VHPIDIRECT getLogicVecA" severity failure; end;
		attribute foreign of getLogicVecA : function is "VHPIDIRECT getLogicVecA";

		function getLogicVecB return logic_vec_b_ptr_t is
		begin assert false report "VHPIDIRECT getLogicVecB" severity failure; end;
		attribute foreign of getLogicVecB : function is "VHPIDIRECT getLogicVecB";

		variable g_logic_vec_a: logic_vec_a_ptr_t := getLogicVecA;
		variable g_logic_vec_b: logic_vec_b_ptr_t := getLogicVecB;

		constant logicArray: std_logic_vector(0 to 8) := ('U', 'X', '0', '1', 'Z', 'W', 'L', 'H', '-');
		
	begin

		report "g_logic_vec_a'length: " & integer'image(g_logic_vec_a'length) severity note;

		for x in g_logic_vec_a'range loop
			report "Asserting VecA [" & integer'image(x) & "]: " & std_logic'image(g_logic_vec_a(x)) severity note;
			assert g_logic_vec_a(x) = logicArray(x) severity failure;
		end loop;

		report "g_logic_vec_b'length: " & integer'image(g_logic_vec_b'length) severity note;

		for x in g_logic_vec_b'range loop
			report "Asserting VecB [" & integer'image(x) & "]: " & std_logic'image(g_logic_vec_b(x)) severity note;
			assert g_logic_vec_b(x) = logicArray(8-x) severity failure;
		end loop;

		wait;
	end process;
end;
