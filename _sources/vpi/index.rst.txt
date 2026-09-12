.. program:: ghdl
.. _COSIM:VPI:Intro:

Introduction
============

Verilog Procedural Interface (VPI) is part of the IEEE Std 1364: `1364-2005 - IEEE Standard for Verilog Hardware Description Language <https://ieeexplore.ieee.org/document/1620780>`_.
It allows Verilog code to invoke C functions, and C functions to invoke Verilog system tasks. VPI is sometimes referred to
as PLI 2, because it replaced the deprecated Program Language Interface (PLI).

VPI provides advanced features, at the cost of having to learn the API. Since this is the user and reference manual for GHDL,
an introduction to VPI is not included. Thus, the reader should have at least a basic knowledge of the interface. A good knowledge of the reference manual.

Unlike VHPIDIRECT, which allows and requires the user to define a custom API between VHDL and C, VPI is itself a pre-defined
API. Hence, all VPI modules need to include a standard header file, ``vpi_user.h``. At the same time, VPI modules need to be
built as shared libraries, and they are dynamically loaded at runtime. This is similar to example :ref:`COSIM:VHPIDIRECT:Examples:shared:shlib`.
However, when using VPI, VHDL sources are agnostic to the existence of C sources.

Information about GHDL's commands related to VPI is available at :ref:`VPI_build_commands` and :option:`--vpi`.
