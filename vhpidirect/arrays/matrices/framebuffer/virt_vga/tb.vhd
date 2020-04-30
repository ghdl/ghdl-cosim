library std;
use std.env.stop;

library ieee;
context ieee.ieee_std_context;

entity tb_vga is
  generic (
    G_SCREEN : natural := 4
  );
end entity;

architecture arch of tb_vga is

  constant clk_period : time := 20 ns;
  signal clk, rst, save_video: std_logic := '0';

  type vga_t is record
    hsync: std_logic;
    vsync: std_logic;
    rgb:   std_logic_vector(2 downto 0);
  end record;

  signal vga: vga_t;

begin

  proc_clk: process
  begin
    clk <= '0'; wait for clk_period/2;
    clk <= '1'; wait for clk_period/2;
  end process;

  proc_main: process
  begin
    report "start simulation" severity note;
    rst <= '1';
    wait for 10*clk_period;
    rst <= '0';
    wait for 35 ms;
    report "end simulation" severity note;
    save_video <= '1';
    wait for 200 ns;
    stop(0);
    wait;
  end process;


  VIRT_VGA: entity work.vga_screen
    generic map (
      G_SCREEN => G_SCREEN
    )
    port map (
      RST   => rst,
      HSYNC => vga.hsync,
      VSYNC => vga.vsync,
      RGB   => vga.rgb,
      VID   => save_video
    );


  UUT: entity work.vga_pattern
    generic map (
      G_SCREEN => G_SCREEN
    )
    port map (
      CLK   => clk,
      EN    => '1',
      RST   => rst,
      HSYNC => vga.hsync,
      VSYNC => vga.vsync,
      RGB   => vga.rgb
    );

end architecture;
