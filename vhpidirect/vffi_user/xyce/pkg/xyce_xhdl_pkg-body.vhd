package body xyce_xhdl_pkg is

  function xyce_init(
    id      : string;
    circuit : string
  ) return integer is
  begin report "VHPIDIRECT xyce_init" severity failure; end;

  function xyce_run(
    id      : string;
    reqTime : real
  ) return integer is
  begin report "VHPIDIRECT xyce_run" severity failure; end;

  function xyce_run(
    id      : string;
    reqTime : real;
    arrTime : real_vector;
    arrVolt : real_vector
  ) return integer is
  begin report "VHPIDIRECT xyce_run 1D" severity failure; end;

  function xyce_run(
    id      : string;
    reqTime : real;
    arr2D   : arr2D_t
  ) return integer is
  begin report "VHPIDIRECT xyce_run 2D" severity failure; end;

  function xyce_read(
    id   : string;
    name : string
  ) return real is
  begin report "VHPIDIRECT xyce_read" severity failure; end;

  procedure xyce_close(
    id : string
  ) is
  begin assert false report "VHPIDIRECT xyce_close" severity failure; end;

end xyce_xhdl_pkg;
