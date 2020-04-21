library ieee;
package fixed_pkg is new ieee.fixed_generic_pkg;

library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

use work.pkg.all;

use work.fixed_pkg.sfixed;
use work.fixed_pkg.to_sfixed;
use work.fixed_pkg.to_slv;
use work.fixed_pkg.to_real;

entity tb_axis_loop is
  generic ( runner_cfg : string );
end entity;

architecture tb of tb_axis_loop is

  -- Simulation constants

  constant clk_period : time    := 20 ns;
  constant data_width : natural := 32;

  -- AXI4Stream Verification Components

  constant m_axis : axi_stream_master_t := new_axi_stream_master(data_length => data_width);
  constant s_axis : axi_stream_slave_t  := new_axi_stream_slave(data_length => data_width);

  -- tb signals and variables

  signal clk, rst, rstn : std_logic := '0';
  signal start, sent, received : boolean := false;

begin

  clk <= not clk after clk_period/2;
  rstn <= not rst;

  main: process
    procedure run_test is begin
      info("Init test");
      wait until rising_edge(clk); start <= true;
      wait until rising_edge(clk); start <= false;
      wait until (sent and received and rising_edge(clk));
      info("Test done");
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test") then
        rst <= '1';
        wait for 15*clk_period;
        rst <= '0';
        run_test;
      end if;
    end loop;
    test_runner_cleanup(runner);
    wait;
  end process;

  stimuli: process
    variable val    : real;
    variable val_fp : sfixed(data_width/2-1 downto -data_width/2); -- input data fixed-point format
    variable last   : std_logic;
  begin
    wait until start and rising_edge(clk);
    sent <= false;
    wait until rising_edge(clk);

    info(
      "Sending matrix [" &
      to_string(matrix'range(1)'right+1) &
      "x" &
      to_string(matrix'range(2)'right+1) &
      "] to UUT..."
    );

    for x in matrix'range(1) loop
      for y in matrix'range(2) loop

        val := matrix(x,y);
        assert val = 0.5 + real(x) * 11.0 + real(y) * 0.11 severity error;

        val_fp := to_sfixed(val, val_fp);

        info(
          to_string(x) & "," & to_string(y) & " -> " &
          to_string(to_real(val_fp)) &
          " [~" &
          to_string(val) &
          "]"
        );

        wait until rising_edge(clk);

        if y = matrix'range(2)'right then last := '1'; else last := '0'; end if;

        push_axi_stream(
          net,
          m_axis,
          to_slv(val_fp),
          tlast => last
        );

      end loop;
    end loop;

    info("matrix sent!");

    wait until rising_edge(clk);
    sent <= true;
  end process;

  receive: process
    variable stdlv  : std_logic_vector(data_width-1 downto 0);
    variable last   : std_logic:='0';
    variable val    : real;
    variable val_fp : sfixed(data_width/2-1 downto -data_width/2); -- output data fixed-point format
  begin
    wait until start and rising_edge(clk);
    received <= false;
    wait for 50*clk_period;

    info(
      "Receiving m_O [" &
      to_string(matrix'range(1)'right+1) &
      "x" &
      to_string(matrix'range(2)'right+1) &
      "] from UUT..."
    );

    for x in matrix'range(1) loop
      for y in matrix'range(2) loop

        pop_axi_stream(
          net,
          s_axis,
          tdata => stdlv,
          tlast => last
        );

        assert not ((y = matrix'range(2)'right) and (last='0'))
        report "Something went wrong. Last misaligned!" severity error;

        val_fp := to_sfixed(stdlv, val_fp);
        val    := to_real(val_fp);

        info(
          to_string(x) & "," & to_string(y) & " <- " &
          to_string(to_real(
          to_sfixed(stdlv, data_width/2-1, -data_width/2)
        )));

      end loop;
    end loop;

    info("matrix read!");

    wait until rising_edge(clk);
    received <= true;
  end process;

--

  uut_vc: entity work.vc_axis
  generic map (
    m_axis => m_axis,
    s_axis => s_axis,
    data_width => data_width
  )
  port map (
    clk  => clk,
    rstn => rstn
  );

end architecture;
