library ieee;
context ieee.ieee_std_context;

use work.vga_cfg_pkg.all;

entity vga_screen is
  generic (
    G_SCREEN  : natural;
    G_WWIDTH  : natural := 0; -- X11 window width
    G_WHEIGHT : natural := 0  -- X11 window height
  );
  port (
    RST:   in std_logic;
    HSYNC: in std_logic;
    VSYNC: in std_logic;
    RGB:   in std_logic_vector(2 downto 0);
    VID:   in std_logic
  );
  constant cfg: VGA_config := VGA_configs(G_SCREEN);
  package tb_pkg is new work.pkg
    generic map (
      G_WIDTH  => cfg.width,
      G_HEIGHT => cfg.height
    );
  use tb_pkg.all;
end entity;

architecture arch of vga_screen is

  constant clk_period : time := (1.0/real(cfg.clk)) * 1 ms;

  signal clk, p_rst, p_hs, p_vs: std_logic := '0';

  signal x: integer range -1 to cfg.width;
  signal y: integer range -1 to cfg.height;

begin

  proc_init: process
  begin
    -- X11 window size
    if G_WWIDTH /= 0 and G_WHEIGHT /= 0 then
      sim_init(G_WWIDTH, G_WHEIGHT);
    else
      sim_init(cfg.width, cfg.height);
    end if;
    wait;
  end process;

  proc_clk: process
  begin
    clk <= '0'; wait for clk_period/2;
    clk <= '1'; wait for clk_period/2;
  end process;

  i_sync: entity work.vga_sync_gen
    generic map (
      G_HPULSE => cfg.hpulse,
      G_HFRONT => cfg.hfront,
      G_WIDTH  => cfg.width,
      G_HBACK  => cfg.hback,
      G_HPOL   => cfg.hpol,
      G_VPULSE => cfg.vpulse,
      G_VFRONT => cfg.vfront,
      G_HEIGHT => cfg.height,
      G_VBACK  => cfg.vback,
      G_VPOL   => cfg.vpol
    )
    port map (
      CLK   => clk,
      EN    => '1',
      RST   => p_rst,
      HSYNC => p_hs,
      VSYNC => p_vs,
      X     => x,
      Y     => y
    );

  b_rst: block
    signal sync: std_logic_vector(1 downto 0);
  begin
    sync(0) <= not VSYNC when cfg.vpol else VSYNC;
    proc_rst: process (clk)
    begin
      if rising_edge(clk) then
        if RST then
          p_rst <= '1';
          sync(1) <= '0';
        else
          sync(1) <= sync(0);
          if sync="01" then
            p_rst <= '0';
          end if;
        end if;
      end if;
    end process;
  end block;

  proc_write: process (clk)
  begin
    if rising_edge(clk) then
      if x/=-1 and y/=-1 then
        screen(y,x) := RGB_to_integer(RGB);
      end if;
    end if;
  end process;

  b_save: block
    signal sync: std_logic_vector(1 downto 0);
  begin
    sync(0) <= not p_vs when cfg.vpol else p_vs;
    process (clk)
      variable frame : natural := 0;
    begin
      if rising_edge(clk) then
        sync(1) <= sync(0);
        if sync="01" then
          save_screenshot(
            screen,
            screen'length(2), --width
            screen'length(1), --height
            frame
          );
          frame := frame + 1;
        end if;
      end if;
    end process;
  end block;

  process
  begin
    wait until VID='1';
    report "save video" severity note;
    sim_cleanup;
    wait until VID='0';
  end process;

end architecture;
