library vunit_lib;
context vunit_lib.vunit_context;

entity tb_xyce_eg_minimal is
  generic (
    runner_cfg : string;
    tb_path    : string
  );
end entity;

architecture tb of tb_xyce_eg_minimal is

  function xyce(cir: string) return integer is
  begin report "VHPIDIRECT xyce" severity failure; end;
  attribute foreign of xyce : function is "VHPIDIRECT xyce";

begin

  main: process
  begin
    test_runner_setup(runner, runner_cfg);
      check_equal(
        xyce(tb_path & "../circuit.cir"),
        1,
        "return code of 'xyce_init'"
      );
    test_runner_cleanup(runner);
    wait;
  end process;

end architecture;