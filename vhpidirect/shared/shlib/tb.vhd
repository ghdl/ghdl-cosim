entity tb is
end tb;

architecture arch of tb is

  function get_rand return integer is
  begin report "VHPIDIRECT ./lib.so get_rand" severity failure; end;
  attribute foreign of get_rand: function is "VHPIDIRECT ./lib.so get_rand";

begin

  process
    variable v : integer;
  begin
    for i in 1 to 10 loop
      v := get_rand;
      report integer'image(i) & ": " & integer'image(v) severity note;
    end loop;
    wait;
  end process;

end;
