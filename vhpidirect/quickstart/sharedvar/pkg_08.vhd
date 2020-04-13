package pkg is
	type int_ptr is access integer;

	impure function c_Int_ptr return int_ptr;
	attribute foreign of c_Int_ptr : function is "VHPIDIRECT getInt_ptr";

	procedure c_printVar;
	attribute foreign of c_printVar : procedure is "VHPIDIRECT printInt";

	type int_ptr_prot is protected
		procedure set ( i: integer);
		impure function get return integer;
	end protected int_ptr_prot;

	shared variable c_Var: int_ptr_prot;

end pkg;

package body pkg is
	impure function c_Int_ptr return int_ptr is begin
		assert false report "VHPI" severity failure;
	end;

	procedure c_printVar is
	begin
		assert false report "c_printVar VHPI" severity failure;
	end;

	type int_ptr_prot is protected body
		variable var: int_ptr := c_Int_ptr;
		procedure set ( i: integer) is begin
			var.all := i;
		end procedure;
		impure function get return integer is begin
			return var.all;
		end get;
	end protected body int_ptr_prot;
end pkg;
  