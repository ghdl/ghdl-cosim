entity tb is
end entity;

architecture arch of tb is
begin
  process begin
    report "Hello linking/bind!" severity note;
    wait;
  end process;
end;
