.. program:: ghdl

.. _COSIM:VHPIDIRECT:Intro:

Introduction
============

Interfacing with foreign languages through VHPIDIRECT is possible on any platform. You can reuse or define a subprogram
in a foreign language (such as `C` or `Ada`) and import it into a VHDL design.

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
