package xyce_xhdl_pkg is

  function xyce_init(
    id      : string;
    circuit : string
  ) return integer;
  attribute foreign of xyce_init : function is "VHPIDIRECT xhdl_init";

  function xyce_run(
    id      : string;
    reqTime : real
  ) return integer;
  attribute foreign of xyce_run : function is "VHPIDIRECT xhdl_run";

  function xyce_run(
    id      : string;
    reqTime : real;
    arrTime : real_vector;
    arrVolt : real_vector
  ) return integer;
  attribute foreign of xyce_run[
    string,
    real,
    real_vector,
    real_vector
    return integer
  ] : function is "VHPIDIRECT xhdl_run_1D";

  type arr2D_t is array (natural range <>, natural range <>) of real;
  function xyce_run(
    id      : string;
    reqTime : real;
    arr2D   : arr2D_t
  ) return integer;
  attribute foreign of xyce_run[
    string,
    real,
    arr2D_t
    return integer
  ] : function is "VHPIDIRECT xhdl_run_2D";

  function xyce_read(
    id   : string;
    name : string
  ) return real;
  attribute foreign of xyce_read : function is "VHPIDIRECT xhdl_read";

  procedure xyce_close(
    id : string
  );
  attribute foreign of xyce_close : procedure is "VHPIDIRECT xhdl_close";

end xyce_xhdl_pkg;
