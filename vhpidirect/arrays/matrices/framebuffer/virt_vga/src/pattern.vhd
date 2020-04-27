library ieee;
context ieee.ieee_std_context;

use work.vga_cfg_pkg.all;

entity vga_pattern is
  generic (
    G_SCREEN: natural
  );
  port (
    CLK:   in  std_logic;
    EN:    in  std_logic;
    RST:   in  std_logic;
    HSYNC: out std_logic;
    VSYNC: out std_logic;
    RGB:   out std_logic_vector(2 downto 0)
  );
end entity;

architecture arch of vga_pattern is

  constant cfg: VGA_config := VGA_configs(G_SCREEN);

  signal x: integer range -1 to cfg.width;
  signal y: integer range -1 to cfg.height;

  signal pclk, pen: std_logic;

  constant clk_period : time := (1.0/real(cfg.clk)) * 1 ms;

begin

  i_pclk: entity work.vga_clk
    generic map (
      G_PERIOD => clk_period
    )
    port map (
      RST  => RST,
      CIN  => CLK,
      EIN  => EN,
      COUT => pclk,
      EOUT => pen
    );

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
      CLK   => pclk,
      EN    => pen,
      RST   => rst,
      HSYNC => HSYNC,
      VSYNC => VSYNC,
      X     => x,
      Y     => y
    );

  process (pclk)
  begin
    if rising_edge(pclk) then
      if pen then
        for c in RGB'range loop
          RGB(c) <= '1' when (x rem (cfg.width/(2**c))) >= cfg.width/(2**(c+1)) else '0';
        end loop;
      end if;
    end if;
  end process;

end architecture;
