architecture arch of tb is
begin
  process begin
    report "Hello cli!" severity note;
    report "genStr: '" & genStr & "'" severity note;
    report "genInt: " & integer'image(genInt) severity note;
    wait;
  end process;
end;
