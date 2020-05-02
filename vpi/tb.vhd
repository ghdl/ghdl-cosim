library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
  generic (
    G_WIDTH : natural := 4;
    G_INST  : natural := 4
  );
end tb;

architecture arch of tb is

  signal a, b : std_logic_vector(G_INST*G_WIDTH-1 downto 0);
  signal c : std_logic_vector(G_INST downto 0);

begin

  i_ent: for x in 0 to G_INST-1 generate
    signal q: std_logic_vector(G_WIDTH downto 0);
  begin
    w_ent: entity work.ent
      port map (
        A => a((x+1)*G_WIDTH-1 downto x*G_WIDTH),
        B => b((x+1)*G_WIDTH-1 downto x*G_WIDTH),
        C => c(x),
        Q => q
      );
    c(x+1) <= q(q'left);
  end generate;

  process
  begin
    a <= std_logic_vector(to_unsigned(2, a'length));
    b <= std_logic_vector(to_unsigned(13, b'length));
    c(0) <= '0';
    wait for 10 ns;
    wait;
  end process;

end architecture;
