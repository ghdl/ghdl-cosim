entity tb is
end tb;

architecture arch of tb is

  function sin (v : real) return real is
  begin
    assert false severity failure;
  end;
  attribute foreign of sin : function is "VHPIDIRECT sin";

begin

  process
    variable r : real;
  begin
    r := 0.0;
    for i in 0 to 10 loop
      report "sin(" & real'image(r) & ") = " & real'image(sin(r)) severity note;
      r := r + 0.1;
    end loop;
    wait;
  end process;

end;
