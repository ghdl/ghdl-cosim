use std.textio.line;
library ieee;
context ieee.ieee_std_context;

entity tb is
end;

architecture arch of tb is

  type rec_t is record
    r_char: character;
    r_int : integer;
  end record;

  type enum_t is (standby, start, busy, done);

  -- Unconstrained array types

  type int_natural1D_t  is array (natural range <>) of integer;
  type real_natural1D_t is array (natural range <>) of real;
  type bool_natural1D_t is array (natural range <>) of boolean;
  type time_natural1D_t is array (natural range <>) of time;
  type rec_natural1D_t  is array (natural range <>) of rec_t;
  type enum_natural1D_t is array (natural range <>) of enum_t;

  type real_natural2D_t is array (natural range <>, natural range <>) of real;

begin

  process

    procedure testCinterface(
      v_char : character;
      v_int  : integer;
      v_nat  : natural;
      v_pos  : positive;
      v_real : real;
      v_bool : boolean;
      v_bit  : bit;
      v_time : time;
      v_rec  : rec_t;
      v_enum : enum_t;
      v_std  : std_logic;
      v_stdv_downto    : std_logic_vector(3 downto 0);
      v_stdv_to        : std_logic_vector(0 to 3);
      v_str  : string;
      v_natural1D_int  : int_natural1D_t;
      v_natural1D_real : real_natural1D_t;
      v_natural1D_bool : bool_natural1D_t;
      v_natural1D_bit  : bit_vector;
      v_natural1D_time : time_natural1D_t;
      v_natural1D_rec  : rec_natural1D_t;
      v_natural1D_enum : enum_natural1D_t;
      v_natural2D_real : real_natural2D_t
    ) is
    begin report "VHPIDIRECT testCinterface" severity failure; end;
    attribute foreign of testCinterface : procedure is "VHPIDIRECT testCinterface";

  begin

    testCinterface(
      v_char => 'k',
      v_int  => -6,
      v_nat  => 9,
      v_pos  => 3,
      v_real => 3.34,
      v_bool => true,
      v_bit  => '1',
      v_time => 20 ns,
      v_rec  => ('y', 5),
      v_enum => busy,
      v_std  => 'Z',
      v_stdv_downto    => "LXZ1",
      v_stdv_to        => ('L', 'X', 'Z', '1'),
      v_str  => "hellostr",
      v_natural1D_int  => (11, 22, 33, 44, 55),
      v_natural1D_real => (0.5, 1.75, 3.33, -0.125, -0.67, -2.21),
      v_natural1D_bool => (false, true, true, false),
      v_natural1D_bit  => ('1', '0', '1', '0'),
      v_natural1D_time => (1 ns, 50 ps, 1.34 us),
      v_natural1D_rec  => (('x', 17),('y', 25)),
      v_natural1D_enum => (start, busy, standby),
      v_natural2D_real => ((0.1, 0.25, 0.5),(3.33, 4.25, 5.0))
    );

    wait;
  end process;
end;
