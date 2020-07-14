architecture arch of tb is
  procedure setGenInt (val: integer) is
  begin report "VHPIDIRECT setGenInt" severity failure; end;
  attribute foreign of setGenInt : procedure is "VHPIDIRECT setGenInt";
begin
  process begin
    report "Hello fcngen!" severity note;
    report "genInt: " & integer'image(genInt) severity note;
    setGenInt(genInt);
    wait;
  end process;
end;
