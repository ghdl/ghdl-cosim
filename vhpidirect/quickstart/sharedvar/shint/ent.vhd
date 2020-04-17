use work.pkg.all;

entity ent is
end ent;

architecture rtl_A of ent is
begin
	process
		constant c_var: shint_t := new_shint(0);
	begin
		report "Entity1: c_Var is " & integer'image(read(c_var));
		report "Entity1: setting c_Var to 1." severity note;
		write(c_var, 1);
		print(c_var);
		wait;
	end process;
end rtl_A ;

architecture rtl_B of ent is
begin
	process
		constant c_var: shint_t := new_shint(0);
	begin
		report "Entity2: c_Var is " & integer'image(read(c_var));
		report "Entity2: setting c_Var to 2." severity note;
		write(c_var, 2);
		print(c_var);
		wait;
	end process;
end rtl_B;
