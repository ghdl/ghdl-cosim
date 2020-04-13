entity tb is
end tb;

architecture arch of tb is

  function rand return integer is
  begin
    assert false report "VHPIDIRECT rand" severity failure;
  end;
  attribute foreign of rand : function is "VHPIDIRECT rand";

begin

  process
    variable v : integer;
  begin
    for i in 1 to 10 loop
      v := rand;
      report integer'image(i) & ": " & integer'image(v) severity note;
    end loop;
    wait;
  end process;

end;
