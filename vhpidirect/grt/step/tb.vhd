entity tb is
end entity;

architecture arch of tb is
begin
  process
    variable cnt: natural := 0;
  begin
    wait for 10 ns;
    report "Hello grt/step! [" & integer'image(cnt) & "]";
    cnt := cnt + 1;
    if cnt = 10 then
      wait;
    end if;
  end process;
end;
