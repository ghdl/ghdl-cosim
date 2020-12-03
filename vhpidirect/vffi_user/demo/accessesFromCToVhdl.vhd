use std.textio.line;
library ieee;
context ieee.ieee_std_context;

entity tb_AccessesFromCToVhdl is
end;

architecture arch of tb_AccessesFromCToVhdl is

  type int_natural1D_t is array (natural range <>) of integer;

begin

  process

    impure function getLine return line is
    begin report "VHPIDIRECT getLine" severity failure; end;
    attribute foreign of getLine : function is "VHPIDIRECT getLine";

--    procedure passAccessesFromCToVhdl(
--    ) is
--    begin report "VHPIDIRECT passAccessesFromCToVhdl" severity failure; end;
--    attribute foreign of passAccessesFromCToVhdl : procedure is "VHPIDIRECT passAccessesFromCToVhdl";

  begin

    report "getLine: " & getLine.all severity note;
    assert getLine.all = "HELLO WORLD" severity failure;

--    passAccessesFromCToVhdl(
--    );

    wait;
  end process;
end;
