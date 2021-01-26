library vunit_lib;
use vunit_lib.run_pkg.all;
use vunit_lib.logger_pkg.all;

entity tb_vunit is
  generic ( runner_cfg : string );
end entity;

architecture tb of tb_vunit is
begin

  main: process
  begin
    test_runner_setup(runner, runner_cfg);
    info("Hello shared/py/vunit!");
    test_runner_cleanup(runner);
    wait;
  end process;

end architecture;
