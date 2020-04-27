library ieee;
context ieee.ieee_std_context;

entity vga_clk is
  generic (
    G_PERIOD: time
  );
  port (
    RST:  in  std_logic;
    CIN:  in  std_logic;
    EIN:  in  std_logic;
    COUT: out std_logic;
    EOUT: out std_logic
  );
end entity;

architecture arch of vga_clk is
begin
  proc_clk: process
  begin
    COUT <= '0'; wait for G_PERIOD/2;
    COUT <= '1'; wait for G_PERIOD/2;
  end process;
  EOUT <= EIN;
end architecture;