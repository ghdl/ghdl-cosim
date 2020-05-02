.. program:: ghdl

.. _COSIM:VHPI:Intro:

Introduction
============

.. ATTENTION::
  Since VPI and VHPI provide very similar features, and because VPI is already supported in GHDL, VHPI is not available (yet).
  Hence, the information in this section is provided for completeness only.

VHDL Programming Interface (VHPI) was introduced in 2007, as an ammendment to IEEE Std 1076-2002: `1076c-2007 - IEEE Standard VHDL Language Reference Manual - Procedural Language Application Interface <https://ieeexplore.ieee.org/document/4299594>`_.
In the 2009, the programming interface was published as part of `1076-2008 - IEEE Standard VHDL Language Reference Manual <https://ieeexplore.ieee.org/document/4772740>`_.
The latest version was published in 2019: `1076-2019 - IEEE Standard for VHDL Language Reference Manual <https://ieeexplore.ieee.org/document/8938196>`_.

Some vendors support C programming interfaces similar to VHPI. For example, Mentor Graphics' ModelSim/QuestaSim supports a
Foreign Language Interface (FLI) that provides functions to have procedural access to information within the simulator, ``vsim``. These allow to traverse the hierarchy, get/set values and control a simulation run. See `Using ModelSim Foreign Language Interface for c – VHDL CoSimulation and for Simulator Control on Linux x86 Platform <https://opencores.org/usercontent/doc/1380917197>`_ and `github.com/andrepool/fli <https://github.com/andrepool/fli>`_.
