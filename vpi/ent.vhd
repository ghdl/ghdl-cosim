library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ent is
  generic (
      G_WIDTH : natural := 4
  );
  port (
    A : in std_logic_vector(G_WIDTH-1 downto 0);
    B : in std_logic_vector(G_WIDTH-1 downto 0);
    C : in std_logic;
    Q : out std_logic_vector(G_WIDTH downto 0)
  );
end entity;

architecture arch of ent is

  signal c_in : unsigned(0 downto 0);

begin

  c_in <= to_unsigned(1,1) when C='1' else to_unsigned(0,1);
  Q <= std_logic_vector(unsigned('0' & A) + unsigned(B) + c_in);

end architecture;
