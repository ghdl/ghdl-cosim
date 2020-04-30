library ieee;
context ieee.ieee_std_context;

package pkg is
  generic (
    G_WIDTH  : natural := 640;
    G_HEIGHT : natural := 480
  );

  type screen_t is
    array ( natural range 0 to G_HEIGHT-1,
            natural range 0 to G_WIDTH-1 ) of integer;

  shared variable screen: screen_t;

  procedure sim_init (width, height: natural);
  attribute foreign of sim_init : procedure is "VHPIDIRECT sim_init";

  -- TODO: pass a fat pointer, so that width and height need not to be passed explicitly
  procedure save_screenshot (
    variable ptr: screen_t;
    width, height: natural;
    id: integer := 0
  );
  attribute foreign of save_screenshot : procedure is "VHPIDIRECT save_screenshot";

  procedure sim_cleanup;
  attribute foreign of sim_cleanup : procedure is "VHPIDIRECT sim_cleanup";

  ---

  function RGB_to_integer (rgb: std_logic_vector(2 downto 0)) return integer;

end pkg;

package body pkg is

  procedure sim_init (width, height: natural) is
  begin report "VHPIDIRECT sim_init" severity failure;
  end procedure;

  procedure save_screenshot (
    variable ptr: screen_t;
    width, height: natural;
    id: integer := 0
  ) is
  begin report "VHPIDIRECT save_screenshot" severity failure;
  end procedure;

  procedure sim_cleanup is
  begin report "VHPIDIRECT sim_cleanup" severity failure;
  end procedure;

  ---

  function RGB_to_integer (rgb: std_logic_vector(2 downto 0)) return integer is
    variable raw24: std_logic_vector(31 downto 0);
  begin
    raw24 := (
      7  downto 0  => rgb(0),
      15 downto 8  => rgb(1),
      23 downto 16 => rgb(2),
         others    => '0'
    );
    return to_integer(unsigned(raw24));
  end function;

end pkg;
