library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavioral of tb is
    
        signal nibble1, nibble2 : unsigned(3 downto 0);
        signal sum_0, sum_1, sum_2, sum_3 : unsigned(3 downto 0);
        signal carry_out_0, carry_out_1, carry_out_2, carry_out_3: std_logic;

    begin

        ent_0: entity work.ent 
                    port map (nibble1 => nibble1,
                             nibble2 => nibble2,
                             sum => sum_0,
                             carry_out => carry_out_0);

        ent_1: entity work.ent 
                    port map (nibble1 => nibble1,
                             nibble2 => nibble2,
                             sum => sum_1,
                             carry_out => carry_out_1);

        ent_2: entity work.ent 
                    port map (nibble1 => nibble1,
                             nibble2 => nibble2,
                             sum => sum_2,
                             carry_out => carry_out_2);

        ent_3: entity work.ent 
                    port map (nibble1 => nibble1,
                             nibble2 => nibble2,
                             sum => sum_3,
                             carry_out => carry_out_3);
        process

        begin

            wait for 10 ns;
            wait;

        end process;

end architecture behavioral;


