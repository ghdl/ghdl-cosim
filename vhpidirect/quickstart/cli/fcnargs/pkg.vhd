package pkg is
  function getGenInt return integer;
  attribute foreign of getGenInt : function is "VHPIDIRECT getGenInt";
end package pkg;

package body pkg is
  function getGenInt return integer is
  begin report "VHPIDIRECT getGenInt" severity failure; end;
end package body pkg;
