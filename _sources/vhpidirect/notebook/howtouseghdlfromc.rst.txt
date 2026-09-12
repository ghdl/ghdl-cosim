.. program:: ghdl

.. _COSIM:VHPIDIRECT:Notebook:HowToUseGHDLFromC:

How to use GHDL from an external C program?
===========================================

.. NOTE:: This content was a dialogue between `@hrvach <https://github.com/hrvach>`_ and `@umarcor <https://github.com/umarcor>`_
   in a question/issue in GHDL's repo, about co-simulation of a Verilog machine around a VHDL CPU: :ghdlsharp:`1512`.

----

@hrvach:

I would be very grateful for some advice. I'm trying to do a project and the CPU core I need to test against only has a VHDL
implementation. My question is - what is the easiest way for me to include the generated ``.o`` in my own project, and then provide
a set of values to the CPU pins and a single clock pulse, read the output, provide new set of values, repeat etc.

----

@umarcor:

HDL simulators need to be the root and absolute managers of their own execution. You can instruct them to execute your foreign
software routines at specific instants or under specific circumstances, but you cannot dethrone them. This is because
"standard" co-simulation interfaces define how to import foreign resources only, not how to export HDL subprograms/components.
That is true for VPI, VHPI, DPI, whatever...

Nevertheless, what you want to achieve is possible for sure, since that is one of the main use cases for co-simulation.
You/we just need to think it upside down.

Before going into further detail, which of the following alternatives do you prefer?

- Write a VHDL testbench where VHDL sources are instantiated, and combine that with C and/or Python resources.
- Keep the VHDL sources untouched and write C and/or Python only.

Both alternatives are functionally equivalent, require a similar level of expertise, and take a similar amount of work/code
length. The answer depends mostly on how comfortable you feel with "writing software in HDL", or whether you identify yourself
as a "mostly software guy who is happier with Python". If you are a C guy, you will lie in-between. In the former, I'll recommend
you to use GHDL's VHPIDIRECT interface, which is what ghdl-cosim repo is mostly about. Otherwise, I'll suggest to use VPI, either
in C or through cocotb.

----

@hrvach:

My goal is to recreate a very old Unix 68010 based machine in Verilog. I use Verilator, the Verilog -> C++ translation and splice
in a software CPU core in C because that's fast enough for a near realtime simulation.

However, after getting the basic functionality done, in order to make it work with actual CPU, I need to get the bus timings
correctly (test and verify handling acknowledgments, cpu-space cycles etc) and the only 68010 model I know of is in VHDL. So,
at the moment I have the memory, bus, logic and peripherals in Verilog, testbench in C that actually has UI in SDL and soft CPU
in C I am looking to replace with the compiled VHDL. All of this is to avoid having to to actual FPGA synthesis for every change
because that takes forever.

I am not that skilled in VHDL, but I could learn how to make a wrapper around the VHDL CPU model if needed. Now that you know
what I'm after, what do you suggest? Once again, thanks for your time and advice!

----

@umarcor:

For clarification, regarding my previous explanation about HDL simulators needing "*to be the root and absolute managers*",
note that Verilator is precisely a way to work around that: it provides everything except the root of the runtime, which you
are in charge of. The concept of a 'ghdlator'|'vhdlator' has been discussed before, but it's not implemented.

The quick answer is, you cannot generate ``*.o`` objects from VHDL (components) and have them included in your C root, the same
way you are including you Verilated (C++) modules. You need to forget about that code structure/architecture. I'm not saying
it is not technically possible; it might be, but not with the currently available open source tools.

Let's leave the VHDL-Verilog co-simulation aside, for now. We'll get back to that later. Let's focus on testing an existing
CPU in VHDL only. As a reference, the CPU will have a single (registered) input port and a single output port, apart from CLK
and RST.

.. code-block:: vhdl

    entity tb is
    end entity;

    architecture test of tb is

      signal clk, rst : std_logic := '0';
      signal iport, oport : std_logic_vector(31 downto 0);

    begin

      clk <= not clk after 10 ns; -- 50 MHz

      process
      begin
        report "Start simulation";
        rst <= '0';
        wait for 100 ns;
        rst <= '1';
        wait for 1 ms;
        report "End simulation";
        std.env.stop(0);
        wait;
      end process;

      process(clk)
      begin
        if rising_edge(clk) then

          iport <= COSIM_FUNCTION(oport);

        end if;
      end process;

      UUT: entity work.CPU
      port map (
        CLK   => clk,
        RST   => rst,
        IPORT => iport,
        OPORT => oport
      );

    end;

That's a very basic VHDL testbench, where RST is kept high for 100 ns and the simulation lasts 1 ms. In each rising edge of
clk, a function receives ``oport`` (the output of the CPU) and generates ``iport`` (the input of the CPU).

You might implement that COSIM_FUNCTION as a plain VHDL function that reads a text file (maybe a CSV) or a binary file (see
`Files – theory & examples <https://vhdlguide.com/2017/08/10/files-theory-examples/>`_). It would be a two column table. In
each execution after the first one, you compare the ``oport`` with the expected output from the previous cycle, and you load
the new value for ``iport``.

However, generating text files in a different language and reading them in VHDL is cumbersome. Binary files make it slightly
easier, but it is not comfortable for handling tables/matrices. Instead, we can implement COSIM_FUNCTION in C. That's what
the VHPIDIRECT examples are about. These are the prototypes of the VHDL function and the corresponding C function:

.. code-block:: vhdl

    function COSIM_FUNCTION ( oport : std_logic_vector(31 downto 0) ) return std_logic_vector(31 downto 0);

.. code-block:: c

    char* COSIM_FUNCTION (char* oport);

``std_logic`` are 9-value enumerations (see :ref:`COSIM:VHPIDIRECT:Declarations`). That's why the vectors are ``char*`` in C.
Typically, we will want to manipulate 32 bit vectors as signed/unsigned integers. Let's fix that:

.. code-block:: vhdl

    process(clk)
    begin
      if rising_edge(clk) then
        iport := std_logic_vector(to_signed(
                   COSIM_FUNCTION( integer(signed(oport)) )
                 , 32));
      end if;
    end process;

.. code-block:: vhdl

    function COSIM_FUNCTION ( oport : integer ) return integer;

.. code-block:: c

    int32_t COSIM_FUNCTION (int32_t oport);

Now, we can use C for evaluating each call to ``COSIM_FUNCTION`` by using an integer representing 32 bit input/output ports.
For example, assuming that the CPU adds 10 to the input every clock cycle and provides it through the output:

.. code-block:: c

    int32_t TABLE[5][2] = {
      { 0, 10 },
      { 1, 11 },
      { 2, 12 },
      { 3, 13 },
      { 4, 14 },
    }

    uint8_t id = 0;

    int32_t COSIM_FUNCTION (int32_t oport) {
      if ( id == 0 ) {
        return TABLE[0][0];
      }
      // Avoid crashing if the simulation is 'too long'
      if ( id > 4 ) {
        return 0;
      }
      assert( oport == TABLE[id++][0]);
      return TABLE[id][1];
    }

In practice, all the C code is loaded in the same memory space as the simulation. Hence, the global variables in the C sources
retain their values for all the duration. Nevertheless, we might keep track of ``id`` in VHDL instead, and pass it as an
additional argument to ``COSIM_FUNCTION``. That's how "frames" are marked in :ref:`COSIM:VHPIDIRECT:Examples:arrays:matrices:vga`
(see also `VGA test pattern <https://github.com/dbhi/vboard/tree/main/vga#vga-test-pattern>`_).

If you don't provide your own ``main`` function, GHDL will take care of that. Yet, you can provide it:

.. code-block:: c

    int32_t TABLE[5][2];

    uint8_t id;

    int32_t COSIM_FUNCTION (int32_t oport) {
      if ( id == 0 ) {
        return TABLE[0][0];
      }
      // Avoid crashing if the simulation is 'too long'
      if ( id > 4 ) {
        return 0;
      }
      assert( oport == TABLE[id++][0]);
      return TABLE[id][1];
    }

    int main(int argc, char* argv) {
      id = 0;
      TABLE = {
        { 0, 10 },
        { 1, 11 },
        { 2, 12 },
        { 3, 13 },
        { 4, 14 },
      };
      return ghdl_main(argc, argv);
    }

Writing your custom ``main`` allows dynamically generating test data before starting the simulation, and/or manipulating GHDL's
CLI arguments. This is explained in :ref:`COSIM:VHPIDIRECT:Wrapping` (see examples in :ref:`COSIM:VHPIDIRECT:Examples:wrapping`).

Effectively, we now have a C interface. Instead of generating an executable binary, we can let GHDL generate a shared library.
That allows loading it in e.g. Python, to have the TABLE generated with, say, some SciPy module. That's what :ref:`COSIM:VHPIDIRECT:Examples:shared`
is about. See also :ghdlsharp:`1398`. Note that you cannot generate a shared lib with a ``main`` function. That's why Python examples
use something else.

Summarising, we defined a callback using VHDL for describing precisely where in the hierarchy to call it and with which frequency
it needs to be called. We also used VHDL for converting the data types to some which are friendly for binding to C. This meaningful
because VHDL is much better designed for manipulating bits/slices that C.

At this point, from a higher level perspective, it is easy to understand VPI. With VPI, you don't need to write the VHDL testbench,
and you don't need to define a ``COSIM_FUNCTION`` providing prototypes in VHDL and C. Instead, you can use the UUT as the top level
of the HDL hierarchy, and there is an interface in C that allows you to "register a callback that is executed every X time". That
callback receives the model/hierarchy of the simulation, which you can navigate through the API for reading/writing values. It
might be misleading with VPI that, despite writting the entrypoint and registering everythin in C, the simulator is still the root
of the execution.

In my opinion, the main limitation of not writing any VHDL testbench is that you are forced to doing all hierarchy navigation and
the type manipulation in C. Moreover, accessing arrays/records through VPI is not supported in GHDL yet (see #1249). However, if
you want to manipulate top-level ports only, it fits the purpose.

Instead of dealing with VPI in C, you can use cocotb, which is a Python wrapper around VPI. Although not exactly my cup of tea
(I'm a VHDL person), cocotb is the fastest growing verification/testing approach: `GitHub Facts About the HDL Industry: Verification Practices <https://larsasplund.github.io/github-facts/verification-practices.html>`_.
You might want to have a look at this WIP discussion about combining cocotb and a top-level VHDL testbench: `umarcor/vunit-cocotb <https://github.com/umarcor/vunit-cocotb/>`_.

Therefore, and this is very important, GHDL's VHPIDIRECT and VPI are mostly equivalent. The main difference is the language you
use for writing your test code. In both cases, GHDL is the root and it executes callbacks. Verbosity is different, each has some
specific features which make things easier/harder, etc. so it's not exactly the same, but almost.

Now, back to your context. You don't want to generate ``iport`` values and/or to assert ``oport`` values in C/Python. You want to
plug the rest of the machine (written in Verilog):

- Option 1. Take ``COSIM_FUNCTION`` and put all your Verilated models inside. That is, let GHDL be the root, and evaluate the C++
  models with a fixed frequency (in terms of simulation time). See :ghdlsharp:`1335`, where a user reported co-simulating microwatt
  (VHDL) and Litedram (Verilog) using this approach. I am not aware of a similar example using VPI, but it should be equivalent.
- Option 2. Forget about this issue. Take VHDL + Verilog sources and synthesise them with ghdl-yosys-plugin + Yosys.

  * Option 2.a. Use Yosys' ``write_verilog`` command for generating post-synthesis Verilog sources. Process those with Verilator.
  * Option 2.b. Use CXXRTL, instead of ``write_verilog``.
  * In any case, simulate as if VHDL or GHDL did never exist; i.e., be the manager of the simulation as you are used to doing with Verilator.

Naturally, options 2.a and 2.b have some caveats, such as not being able to simulate non-synthesisable VHDL models (Verilator is
constrained to the synthesisable subset of Verilog anyway), or being lost in the conversion/mangling/flattening/casing. That's
why I explained all the details about VHPIDIRECT, and that's why I think that VHPIDIRECT + Verilator is the way to go. Still,
if you want to treat VHDL sources as a black box with "simple" port types, Yosys might be the best approach. Yosys/CXXRTL is
also useful for comparing pre-synthesis and post-synthesis behaviour, even if you pick VHPIDIRECT/VPI + Verilator for development.

Closing remarks:

* I wrote all the code examples above off the top of my head. There might be a lot of typos/bugs. Please, find working examples
  in :ref:`COSIM:VHPIDIRECT:Examples` (all of those are tested in CI).
* I did never use CXXRTL, and I just run a couple of examples with cocotb.
* GHDL's implementation of VHPIDIRECT is not compliant with the usage of the term/keyword VHPIDIRECT in the VHDL LRM, where it's
  part of VHPI. The concept of how VHPI/VHPIDIRECT work in the LRM is closer to VPI than to a Foreign Function Interface (FFI).
  However, what I explained above is essentially a FFI. That's why there is an on-going discussion in the VHDL Analysis and
  Standardisation Group (VASG) about including a FFI in the next revision of the standard: `[LCS-202x] VHDL DPI/FFI based on GHDL’s implementation of VHPIDIRECT <https://umarcor.github.io/ghdl-cosim/vhdl202x>`_.
