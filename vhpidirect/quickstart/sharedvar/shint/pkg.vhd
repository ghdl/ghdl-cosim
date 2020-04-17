package pkg is

  procedure write_int ( id: integer; v: integer ) ;
  attribute foreign of write_int : procedure is "VHPIDIRECT write_int";

  impure function read_int ( id: integer ) return integer;
  attribute foreign of read_int : function is "VHPIDIRECT read_int";

  procedure print_int ( id: integer );
  attribute foreign of print_int : procedure is "VHPIDIRECT print_int";

  type shint_t is record
    -- Private
    p_id: integer;
  end record;

  impure function new_shint(id: integer := -1) return shint_t;
  procedure write ( shint: shint_t; v: integer );
  impure function read ( shint: shint_t ) return integer;
  procedure print ( shint: shint_t );

end pkg;

package body pkg is

  -- VHPIDIRECT

  procedure write_int ( id: integer; v: integer ) is begin
    assert false report "VHPIDIRECT write_int" severity failure;
  end;

  impure function read_int ( id: integer ) return integer is begin
    assert false report "VHPIDIRECT read_int" severity failure;
  end;

  procedure print_int ( id: integer ) is begin
    assert false report "VHPIDIRECT print_int" severity failure;
  end;

  -- VHDL

  impure function new_shint ( id: integer := -1 ) return shint_t is begin
    return (p_id => id);
  end;

  procedure write ( shint: shint_t; v: integer ) is begin
    write_int(shint.p_id, v);
  end;

  impure function read ( shint: shint_t ) return integer is begin
    return read_int(shint.p_id);
  end function;

  procedure print ( shint: shint_t ) is begin
    print_int(shint.p_id);
  end;

end pkg;
