entity tb is
end tb;

architecture arch of tb is

  procedure cproc is
  begin
    assert false severity failure;
  end;
  attribute foreign of cproc : procedure is "VHPIDIRECT custom_procedure";

  procedure cproc_wargs ( x: integer ) is
  begin
    assert false severity failure;
  end;
  attribute foreign of cproc_wargs : procedure is "VHPIDIRECT custom_procedure_withargs";

  function cfunc return integer is
  begin
    assert false severity failure;
  end;
  attribute foreign of cfunc : function is "VHPIDIRECT custom_function";

  function cfunc_wargs ( x: integer ) return integer is
  begin
    assert false severity failure;
  end;
  attribute foreign of cfunc_wargs : function is "VHPIDIRECT custom_function_withargs";

begin

  process
  begin
    cproc;
    cproc_wargs(17);
    report "cfunc: " & integer'image( cfunc ) severity note;
    report "cfunc_wargs: " & integer'image( cfunc_wargs(21) ) severity note;
    wait;
  end process;

end;
