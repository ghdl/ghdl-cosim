package pkg is

  function getMatSize (dim: integer) return integer;
  attribute foreign of getMatSize : function is "VHPIDIRECT getMatSize";

  type matrix_t is array (0 to getMatSize(0)-1, 0 to getMatSize(1)-1) of real;
  type matrix_acc_t is access matrix_t;

  impure function getMatPointer return matrix_acc_t;
  attribute foreign of getMatPointer : function is "VHPIDIRECT getMatPointer";

  shared variable matrix: matrix_acc_t := getMatPointer;

end package pkg;

package body pkg is

  function getMatSize (dim: integer) return integer is
  begin report "VHPIDIRECT getMatSize" severity failure; end;

  impure function getMatPointer return matrix_acc_t is
  begin report "VHPIDIRECT getMatPointer" severity failure; end;

end package body pkg;
