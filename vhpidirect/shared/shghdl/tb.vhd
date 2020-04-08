entity tb is
end entity;

architecture arch of tb is
begin
  process begin
    report "Hello shared/shghdl!" severity note;
    wait;
  end process;
end;
