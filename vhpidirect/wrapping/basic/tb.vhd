entity tb is
end entity;

architecture arch of tb is
begin
  process begin
    report "Hello wrapping/basic!" severity note;
    wait;
  end process;
end;
