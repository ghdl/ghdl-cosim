package pkg is
	type int_ptr is access integer;

	function c_Int_ptr return int_ptr;
	attribute foreign of c_Int_ptr : function is "VHPIDIRECT getInt_ptr";

	procedure c_printVar;
	attribute foreign of c_printVar : procedure is "VHPIDIRECT printInt";

	shared variable c_Var : int_ptr := c_Int_ptr;

	procedure setVar ( int: integer );

	impure function getVar return integer;

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

	procedure setVar ( int: integer ) is begin
		c_Var.all := int;
	end;

	impure function getVar return integer is begin
		return c_Var.all;
	end;
end package body pkg;
