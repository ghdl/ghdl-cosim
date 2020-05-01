library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavioral of tb is
    
        signal nibble1, nibble2, sum : unsigned(3 downto 0);

    begin
        
        process

        begin

            wait for 10 ns;
            wait;

        end process;

        sum <= nibble1 + nibble2;

end architecture behavioral;


