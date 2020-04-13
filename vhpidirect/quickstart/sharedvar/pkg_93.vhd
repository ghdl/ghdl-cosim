package pkg is
	type int_ptr is access integer;

	function c_Int_ptr return int_ptr;
	attribute foreign of c_Int_ptr : function is "VHPIDIRECT getInt_ptr";

	procedure c_printVar;
	attribute foreign of c_printVar : procedure is "VHPIDIRECT printInt";

	shared variable c_Var : int_ptr := c_Int_ptr;
end package pkg;

package body pkg is
	function c_Int_ptr return int_ptr is
	begin
		assert false report "c_Int_ptr VHPI" severity failure;
	end;

	procedure c_printVar is
	begin
		assert false report "c_printVar VHPI" severity failure;
	end;
end package body pkg;
