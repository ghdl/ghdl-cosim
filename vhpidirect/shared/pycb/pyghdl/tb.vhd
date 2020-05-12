entity tb is
end entity;

architecture arch of tb is

  type arr_t is array (0 to 4) of integer;

  procedure plot(x, y: arr_t; l: integer) is
  begin assert false report "VHPIDIRECT plot" severity failure; end;
  attribute foreign of plot: procedure is "VHPIDIRECT ghdl_plot";

  constant x: arr_t := (1, 2, 3, 4, 5);
  constant y: arr_t := (11, 2, 38, 45, 57);

begin
  process begin
    report "Hello shared/shghdl!" severity note;
    plot(x, y, x'length);
    wait;
  end process;
end;
