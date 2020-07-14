library ieee;
context ieee.ieee_std_context;

library ghdl;
use ghdl.vffi_user.swap;

entity tb is
end;

architecture arch of tb is
begin
  process

    subtype svec_t is std_logic_vector(0 to 127);

    procedure cryptData (
      din  : svec_t;
      key  : svec_t;
      dout : svec_t;
      blen : integer
    ) is
    begin assert false report "VHPIDIRECT cryptData" severity failure; end;
    attribute foreign of cryptData : procedure is "VHPIDIRECT cryptData";

    variable vin  : svec_t := x"3925841D02DC09FBDC118597196A0B32";
    variable vkey : svec_t := x"2B7E151628AED2A6ABF7158809CF4F3C";
    variable vout : svec_t;

    constant vexp : svec_t := x"7DFDFF39CC79C14315BAF5EF727CC0CF";

  begin

    report "Hello crypto!" severity note;

    cryptData(swap(vin), swap(vkey), vout, vin'length/8);

    assert swap(vout) = vexp severity failure;

    wait;
  end process;
end;
