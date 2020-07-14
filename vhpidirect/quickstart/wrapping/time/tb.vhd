entity tb is
end;

architecture arch of tb is

   signal sum : integer;
   signal n_sum : integer;
   signal clk : bit;
   signal rst : bit;

begin

  process
  begin
    report "Reset" severity note;
    rst <= '0';
    wait for 1 ns;
    rst <= '1';
    wait for 1 ns;
    report "Start of clock" severity note;
    for i in 0 to 1000 loop
      clk <= not clk;
      wait for 1 ns;
    end loop;
    report "End of clock" severity note;
    wait;
  end process;

  process (clk, rst)
  begin
    if rst = '1' then
      sum <= 0;
    elsif clk = '1' and clk'event then
      sum <= n_sum;
    end if;
  end process;

  n_sum <= sum + 1;

end;
