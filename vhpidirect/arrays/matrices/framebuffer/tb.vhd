use work.pkg.all;

entity tb is
end tb;


architecture test of tb is
  constant c_width  : integer := screen'length(2);
  constant c_height : integer := screen'length(1);
begin
  process
    variable h, i, j, d_x, d_y: integer;
    constant w : natural := 100;
  begin
    sim_init(800, 600); -- X11 window size
    report "screen size: " & to_string(c_width) & "x" & to_string(c_height) severity note;
    report "pattern: test" severity note;

    for h in 0 to 15 loop
      d_x := h * (c_width-w-1)/15;
      d_y := h * (c_height-w-1)/15;

      for j in 0 to c_height-1 loop
        for i in 0 to c_width-1 loop
          screen(j,i) := 16#FFFF00#;
        end loop;
      end loop;

      for j in d_y to d_y+w loop
        for i in d_x to d_x+w loop
          screen( j, i ) := 16#00FFFF#;
        end loop;
      end loop;

      save_screenshot(
        screen,
        c_width,
        c_height,
        h
      );
    end loop;

    sim_cleanup;
    wait;
  end process;
end architecture;


library ieee;
context ieee.ieee_std_context;

architecture bars of tb is
  constant c_width  : integer := screen'length(2);
  constant c_height : integer := screen'length(1);
begin
  process
    variable color: std_logic_vector(2 downto 0) := (others=>'0');
  begin
    sim_init(800, 600); -- X11 window size
    report "screen size: " & to_string(c_width) & "x" & to_string(c_height) severity note;
    report "pattern: bars" severity note;

    for j in 0 to c_height-1 loop
      for i in 0 to c_width-1 loop
        for c in color'range loop
          color(c) := '1' when (i rem (c_width/(2**c))) >= c_width/(2**(c+1)) else '0';
        end loop;
        screen(j,i) := RGB_to_integer(color);
      end loop;
    end loop;

    save_screenshot(
      screen,
      c_width,
      c_height
    );

    sim_cleanup;
    wait;
  end process;
end architecture;
