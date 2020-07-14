package body vffi_user is

  function swap (datain : std_logic_vector(0 to 127)) return std_logic_vector is
    variable v_data : std_logic_vector(0 to 127);
  begin
    for i in 0 to 15 loop
      for y in 0 to 7 loop
        v_data((i*8)+y) := datain((i*8)+7-y);
      end loop;
    end loop;
    return v_data;
  end function;

end vffi_user;