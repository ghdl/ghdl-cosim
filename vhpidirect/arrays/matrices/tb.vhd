library ieee;
package fixed_pkg is new ieee.fixed_generic_pkg;

library ieee;
context ieee.ieee_std_context;

use work.pkg.all;

use work.fixed_pkg.all;

entity tb is
end;

architecture arch of tb is

begin
  process
    variable val: real;
  begin

    report "matrix size: " & to_string(matrix'range(1)'right+1) & " " & to_string(matrix'range(2)'right+1) severity note;

    for x in matrix'range(1) loop
      for y in matrix'range(2) loop
        val := matrix(x,y);
        assert val = 0.5 + real(x) * 11.0 + real(y) * 0.11 severity error;
        matrix(x,y) := to_real(to_sfixed(val, 14, -10) * to_sfixed(0.1, 7, -8));
        report to_string(x) & "," & to_string(y) & ": " & real'image(val) & " " & real'image(matrix(x,y)) severity note;
      end loop;
    end loop;

    wait;
  end process;
end;
