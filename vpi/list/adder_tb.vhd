library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_tb is
end adder_tb;

architecture behavioral of adder_tb is
    component adder
        port
        (
            nibble1, nibble2 : in unsigned(3 downto 0); 
            sum       : out unsigned(3 downto 0); 
            carry_out : out std_logic
        );
    end component adder;
    for adder_0: adder use entity work.adder;
    signal nibble1, nibble2, sum : unsigned(3 downto 0);
    signal carry_out : std_logic;
begin
    adder_0: adder port map (nibble1 => nibble1,
                             nibble2 => nibble2,
                             sum => sum,
                             carry_out => carry_out);

    process
    begin
        wait for 10 ns;
        wait;
    end process;
end architecture behavioral;


