library ieee;
use ieee.std_logic_1164.all;

use work.pkg.all;

entity ent is
end ent;

architecture rtl_A of ent is
begin
	process
		variable struc: c_struct := (
			logic_bit => 'X',
			logic_vec => ('H', '0', 'H', '0', 'X', '1', 'X', '1'),
			int       => 144
		);
		variable cStruct_acc: c_struct_ptr := c_getStruct;
	begin
		report "Entity1: C Print of VHDL-record.";
		c_printAndChangeStruct(struc);
		report "Entity1: C changed VHDL-record's integer to: " &integer'image(struc.int);

		report "Entity1: C-struct's integer: " & integer'image(cStruct_acc.int);
		cStruct_acc.int := -678;
		report "Entity1: VHDL changed C-struct's integer to: " &integer'image(cStruct_acc.int);
		report "Entity1: C Print of C-struct.";
		c_printStruct(cStruct_acc.ALL);
		wait;
	end process;
end rtl_A ;

architecture rtl_B of ent is
begin
	process
		variable struc: c_struct := (
			logic_bit => '-',
			logic_vec => ('U', '1', 'U', '1', '-', '0', '-', '0'),
			int       => -123
		);
		variable cStruct_acc: c_struct_ptr := c_getStruct;
	begin
		report "Entity2: C Print of C-struct.";
		c_printStruct(cStruct_acc.ALL);

		report "Entity2: C Print of VHDL-record.";
		c_printAndChangeStruct(struc);
		report "Entity2: C changed VHDL-record's integer to: " &integer'image(struc.int);

		report "Entity2: C-struct's integer: " & integer'image(cStruct_acc.int);
		cStruct_acc.int := 786;
		report "Entity1: VHDL changed C-struct's integer to: " &integer'image(cStruct_acc.int);
		report "Entity1: C Print of C-struct.";
		c_printStruct(cStruct_acc.ALL);
		wait;
	end process;
end rtl_B;
