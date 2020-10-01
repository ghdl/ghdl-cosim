use std.textio.line;
library ieee;
context ieee.ieee_std_context;

entity tb_AccessesFromVhdlToC is
end;

architecture arch of tb_AccessesFromVhdlToC is

  type int_natural1D_t is array (natural range <>) of integer;

begin

  process

    procedure passAccessesFromVhdlToC(
      v_natural1D_int  : int_natural1D_t
    ) is
    begin report "VHPIDIRECT passAccessesFromVhdlToC" severity failure; end;
    attribute foreign of passAccessesFromVhdlToC : procedure is "VHPIDIRECT passAccessesFromVhdlToC";

  begin

    passAccessesFromVhdlToC(
      v_natural1D_int  => (11, 22, 33, 44, 55)
    );

    wait;
  end process;
end;
