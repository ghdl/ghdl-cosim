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

* `Verilog Procedural Interface <https://en.wikipedia.org/wiki/Verilog_Procedural_Interface>`_ (VPI), also known as
  Program Language Interface (PLI) 2.0.

* `VHDL Programming Interface <https://ieeexplore.ieee.org/document/4299594>`_ (VHPI), or specific implementations,
  such as Foreign Language Interface (FLI).

* Generation of C/C++ models/sources through a transpiler.

VPI and VHPI are complex APIs which allow to inspect the hierarchy, set callbacks and/or assign signals. Because
provided features are similar, GHDL supports VPI only. Furthermore, as an easier to use alternative, GHDL features a
custom coexecution procedure named VHPIDIRECT, similar to SystemVerilog's DPI (`Direct Programming Interface <https://en.wikipedia.org/wiki/SystemVerilog_DPI>`_).
As of today, generation of C++/SystemC models à la `Verilator <https://www.veripool.org/wiki/verilator>`_ is not
supported. However, a *vhdlator*/*ghdlator* might be available in the future.

:ref:`VHPIDIRECT <COSIM:VHPIDIRECT:Intro>` is easier to use than :ref:`VPI <COSIM:VPI:Intro>`/:ref:`VHPI <COSIM:VHPI:Intro>`
because, as the name suggests, it is a direct interface. However, on the one hand VHPIDIRECT requires modification of
VHDL sources, which might not be possible or desirable in certain contexts. On the other hand, VPI/VHPI allow use cases
which are not yet possible with VHPIDIRECT, such as controlling execution time steps. It is suggested to read the quick
start examples of both interfacing mechanisms, in order to get a feel of the differences.


.. toctree::
   :caption: VHPIDIRECT
   :hidden:

   vhpidirect/index
   vhpidirect/declarations
   vhpidirect/wrapping
   vhpidirect/linking
   vhpidirect/dynamic
   vhpidirect/grt
   vhpidirect/examples/index
   vhpidirect/mistakes


.. toctree::
   :caption: VPI
   :hidden:

   vpi/index
   vpi/examples/index


.. toctree::
   :caption: VPHI
   :hidden:

   vhpi/index
