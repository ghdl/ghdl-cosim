library vunit_lib;
use vunit_lib.run_pkg.all;
use vunit_lib.logger_pkg.all;

entity tb_abrt is
  generic ( runner_cfg : string );
end entity;

architecture tb of tb_abrt is

  constant block_len : natural := 5;

begin

  main: process
    variable val, ind: integer;
  begin
    test_runner_setup(runner, runner_cfg);
    info("Hello wrapping/exitcb/py_vunit!");
    test_runner_cleanup(runner);
    wait;
  end process;

end architecture;
