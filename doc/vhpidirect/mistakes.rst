.. program:: ghdl

.. _COSIM:VHPIDIRECT:Mistakes:

Common mistakes
===============

* Although function overloading is supported in VHDL, it is not possible in C. Hence, it should be avoided to declare
  multiple procedures/functions which map to the same foreign subprogram. For the compiler, there is only one definition
  of the imported function. So, if different prototypes/profiles are declared, weird things may happen. See :ghdlsharp:`639`.

* If a procedure/function is decorated with the ``foreign`` attribute, apart from a matching body in VHDL, the foreign
  subprogram **must** be defined (linked) for elaboration to succeed. This is required even when it is not used in the
  design. In context where conditional inclusion of VHPIDIRECT features is required, it is suggested to provide
  alternative (dummy) sources for either VHDL packages or C sources (see :ghdlsharp:`793`).
