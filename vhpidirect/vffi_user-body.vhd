package body vffi_user is

  -- For each byte, reverse the bits:
  -- From  0  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 15 | ...
  -- To    7  6  5  4  3  2  1  0 | 15 14 13 12 11 10  9  8 | ...
  --
  function reverseBitsInBytes (datain : std_logic_vector(0 to 127)) return std_logic_vector is
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
