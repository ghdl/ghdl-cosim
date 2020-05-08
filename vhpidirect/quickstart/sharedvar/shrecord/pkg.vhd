library ieee;
use ieee.std_logic_1164.all;

package pkg is
		
	type c_struct is record
		logic_bit : std_ulogic;
		logic_vec : std_ulogic_vector(7 downto 0);
		int				: integer;
	end record c_struct;

	type c_struct_ptr is access c_struct;
  
	procedure c_printAndChangeStruct(struct: c_struct);
	attribute foreign of c_printAndChangeStruct: procedure is "VHPIDIRECT printAndChangeStruct";
	
	procedure c_printStruct(struct: c_struct);
	attribute foreign of c_printStruct: procedure is "VHPIDIRECT printStruct";

	impure function c_getStruct return c_struct_ptr; -- VHDL 08 requires the function to be declared as impure, VHDL 93 does not
	attribute foreign of c_getStruct: function is "VHPIDIRECT getStruct";

end pkg;

package body pkg is
  procedure c_printAndChangeStruct(struct: c_struct) is
	begin
		assert false report "VHDPI c_printAndChangeStruct" severity failure;
	end procedure c_printAndChangeStruct;

  procedure c_printStruct(struct: c_struct) is
	begin
		assert false report "VHDPI c_printStruct" severity failure;
	end procedure c_printStruct;

	impure function c_getStruct return c_struct_ptr is
	begin
		assert false report "VHDPI c_getStruct" severity failure;
	end function c_getStruct;

end pkg;
