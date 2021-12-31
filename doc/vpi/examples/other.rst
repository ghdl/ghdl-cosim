.. _COSIM:VPI:Examples:other:

Other co-simulation projects
############################

This section contains references to other co-simulation projects based on GHDL and VPI.

cocotb
======

`cocotb <https://github.com/cocotb/cocotb>`__ is a coroutine based cosimulation library for writing VHDL and Verilog
testbenches in Python. It provides a shared library for binding the VPI interface to Python scripts. As a result, from
Python, users can read/set top-level ports or signals in the testbench, without modifying HDL sources at all. Cocotb
supports other open source simulators (Icarus Verilog or Verilator) and it can also interact with commercial tools through
VHPI.

GHDL VPI virtual board
======================

`GHDL VPI virtual board <https://gitlab.ensta-bretagne.fr/bollenth/ghdl-vpi-virtual-board>`__ is a VPI application that
virtualizes the IOs of a Digilent Nexys-4 like board. It provides a testbench and a matching GUI for users/students to test
their designs as if they had a physical board, instead of examining waveforms. Yet, waves are dumped and can be inspected in
GTKWave, as in a traditional workflow. Available peripherals are 7 segment displays, buttons, switches and LEDs.

.. image:: https://gitlab.ensta-bretagne.fr/bollenth/ghdl-vpi-virtual-board/-/raw/master/images/screenshot_main_window.png
   :align: center
   :target: https://gitlab.ensta-bretagne.fr/bollenth/ghdl-vpi-virtual-board

GHDL-Cocotb GUI Simulation
==========================

`GHDL-Cocotb GUI Simulation <https://blog.chuckstechtalk.com/software/2021/12/27/interactive-vhdl-testbench.html>`__ is a VPI application that
demonstrates how to create a Python-based interactive GUI simulation using ghdl, cocotb, and pygame. It provides a
testbench and a matching GUI with I/O peripherals for testing a design, instead of examining waveforms. While 
similar to the `GHDL VPI virtual board <https://gitlab.ensta-bretagne.fr/bollenth/ghdl-vpi-virtual-board>`__ example, using
`cocotb <https://github.com/cocotb/cocotb>`__ and `pygame <https://www.pygame.org>__` makes interactive GUI creation more dynamic
than using a compiled language (such as C++).

.. image:: https://github.com/chuckb/ghdl-interactive-sim/raw/8a466215dd18c6c809dd96f8d03fa53cad8417c2/test/images/screen_shot.png
   :align: center
   :target: https://github.com/chuckb/ghdl-interactive-sim
