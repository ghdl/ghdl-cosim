entity tb is
end tb;

architecture arch of tb is
begin

	entA : entity work.ent(rtl_A);
	entB : entity work.ent(rtl_B);

	process
	begin
		report "Testbench." severity note;
		wait;
	end process;
end;
