use work.pkg.all;

entity ent is
end ent;

architecture rtl_A of ent is
begin
	process
	begin
		report "Entity1 calling c_print(1)." severity note;
		c_printInt(1);
		wait;
	end process;
end rtl_A;

architecture rtl_B of ent is
begin
	process
	begin
		report "Entity2 calling c_print(2)." severity note;
		c_printInt(2);
		wait;
	end process;
end rtl_B;
