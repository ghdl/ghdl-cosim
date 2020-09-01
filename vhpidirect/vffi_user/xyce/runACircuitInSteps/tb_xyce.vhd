library vunit_lib;
context vunit_lib.vunit_context;

use work.xyce_pkg.xyce_t;

entity tb_xyce_eg_in_steps is
  generic (
    runner_cfg : string;
    tb_path    : string;
    circuit    : string := "../circuit.cir"
  );
end entity;

architecture tb of tb_xyce_eg_in_steps is begin
  main: process
    variable xyce : xyce_t;
  begin
    test_runner_setup(runner, runner_cfg);
    info(tb_path);
    xyce.init("run a circuit in steps", tb_path & circuit);
    for i in 0 to 9 loop
      xyce.run(0.0 + real(i+1) * 0.1);
    end loop;
    xyce.close;
    test_runner_cleanup(runner);
    wait;
  end process;
end architecture;