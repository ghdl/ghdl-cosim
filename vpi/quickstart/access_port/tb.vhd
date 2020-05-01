library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
    port(nibble1,nibble2 : in unsigned(3 downto 0);
         sum : out unsigned(3 downto 0));

end tb;

architecture behavioral of tb is
    begin
        
        process

        begin

            wait for 10 ns;
            wait;

        end process;

        sum <= nibble1 + nibble2;

end architecture behavioral;


