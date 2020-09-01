library vunit_lib;
context vunit_lib.vunit_context;

use work.xyce_pkg.xyce_t;
use work.xyce_pkg.arr2D_t;

entity tb_xyce_eg_with_dacs_2D is
  generic (
    runner_cfg : string;
    tb_path    : string;
    circuit    : string := "../circuit_DACs.cir"
  );
end entity;

architecture tb of tb_xyce_eg_with_dacs_2D is begin

  main: process
    constant steps: natural := 10;
    constant total_sim_time : real := 20.0e-4;

    variable arr2D : arr2D_t(0 to 1, 0 to 8) := (
      (0.0, 0.1e-4, 0.2e-4, 0.4e-4, 0.5e-4, 0.7e-4, 0.8e-4, 1.0e-4, 1.1e-4),
      (0.0, 0.0, 3.0, 3.0, 0.0, 0.0, 3.0, 3.0, 0.0)
    );

    variable xyce : xyce_t;
    variable arrT : real_vector(arr2D'range(2));
    variable response : real;
  begin
    test_runner_setup(runner, runner_cfg);
    xyce.init("run a circuit with dacs (2D)", tb_path & circuit);

    for i in arrT'range loop
      arrT(i) := arr2D(0, i);
    end loop;

    for i in 0 to steps-1 loop
      xyce.run(
        0.0 + real(i+1) * 0.1 * total_sim_time,
        arr2D
      );

      response := xyce.read("YMEMRISTORRES");
      info("response: " & to_string(response));

      -- update time array to repeat pulse
      for j in arrT'range loop
        arr2D(0, j) := arrT(j) + xyce.reqT;
      end loop;
    end loop;

    xyce.close;
    test_runner_cleanup(runner);
    wait;
  end process;

end architecture;