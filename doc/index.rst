.. program:: ghdl

.. _COSIM:

Co-simulation with GHDL
#######################

.. index:: interfacing

.. index:: other languages

.. index:: foreign

.. index:: VPI

.. index:: VHPI

.. index:: VHPIDIRECT

.. index:: SystemC

This repository contains documentation and working examples about how to co-simulate VHDL and other languages through
GHDL's foreign interfaces. Since specific features of the language and the tool are used, it is suggested for users
who are new to either `GHDL` or `VHDL` to first read the :ref:`USING:QuickStart` in the main documentation
(`ghdl.rtfd.io <https://ghdl.rtfd.io>`_).

Three main approaches are used to co-simulate (co-execute) VHDL sources along with software applications written in a
language other than VHDL (typically C/C++/SystemC):

* Verilog Procedural Interface (VPI), also known as Program Language Interface (PLI) 2.0.

* VHDL Procedural Interface (VHPI), or specific implementations, such as Foreign Language Interface (FLI).

* Generation of C/C++ models/sources through a transpiler.

VPI and VHPI are complex APIs which allow to inspect the hierarchy, set callbacks and/or assign signals. Because
provided features are similar, GHDL supports VPI only. Furthermore, as an easier to use alternative, GHDL features a
custom coexecution procedure named VHPIDIRECT, similar to SystemVerilog's Direct Programming Interface (DPI).
As of today, generation of C++/SystemC models à la Verilator is not supported. However, a *vhdlator*/*ghdlator* might
be available in the future.

.. toctree::
   :caption: VHPIDIRECT

   vhpidirect/declarations
   vhpidirect/wrapping
   vhpidirect/linking
   vhpidirect/dynamic
   vhpidirect/grt
   vhpidirect/examples/index

Interfacing with foreign languages through VHPIDIRECT is possible on any platform.
You can define a subprogram in a foreign language (such as `C` or
`Ada`) and import it into a VHDL design.

.. NOTE::
  GHDL supports different backends, and not all of them generate binary artifacts. Precisely, ``mcode`` is an in-memory
  backend. Hence, the examples need to be built/executed with either LLVM or GCC backends. A few of them, the ones that
  do not require linking object files, can be used with mcode.

.. ATTENTION::
  As a consequence of the runtime copyright, you are not allowed to distribute an
  executable produced by GHDL without allowing access to the VHDL sources. See
  :ref:`INTRO:Copyrights`.

.. TIP::
  See :ghdlsharp:`1053` for on-going work with regard to VHPIDIRECT.

.. toctree::
   :caption: VPI

   vpi/examples/index

See :ref:`VPI_build_commands`.

TBC
