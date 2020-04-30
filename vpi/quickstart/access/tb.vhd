library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavioral of tb is
    
        signal nibble1, nibble2, sum : unsigned(3 downto 0);
        signal carry_out : std_logic;

    begin

        ent_0: entity work.ent 
                    port map (nibble1 => nibble1,
                             nibble2 => nibble2,
                             sum => sum,
                             carry_out => carry_out);
        process

        begin

            wait for 10 ns;
            wait;

        end process;

end architecture behavioral;


