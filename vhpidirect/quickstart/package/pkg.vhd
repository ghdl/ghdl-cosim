package pkg is
	procedure c_printInt(val: integer);
	attribute foreign of c_printInt : procedure is "VHPIDIRECT printInt";
end package pkg;

package body pkg is
	procedure c_printInt(val: integer) is
	begin report "c_printInt VHPI" severity failure; end;
end package body pkg;
