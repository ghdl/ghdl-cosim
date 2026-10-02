.. program:: ghdl

.. _COSIM:VHPIDIRECT:Notebook:Mistakes:

Common mistakes
===============

* Although function overloading is supported in VHDL, it is not possible in C.
  Hence, it should be avoided to declare multiple procedures/functions which map to the same foreign subprogram.
  For the compiler, there is only one definition of the imported function.
  So, if different prototypes/profiles are declared, weird things may happen.
  See :ghdlsharp:`639`.

* If a procedure/function is decorated with the ``foreign`` attribute, apart from a matching body in VHDL, the foreign
  subprogram **must** be defined (linked) for elaboration to succeed.
  This is required even when it is not used in the design.
  In context where conditional inclusion of VHPIDIRECT features is required, it is suggested to provide alternative
  (dummy) sources for either VHDL packages or C sources (see :ghdlsharp:`793`).

* There are some corner cases when using large variables/signals.
  When you try to allocate a single object which is too large, GHDL will complain.
  That can be fixed with :option:`--max-stack-alloc`.
  However, when you allocate multiple objects which are smaller than the limit, but the last one overflows, GHDL will
  not complain, it will crash instead.
  In this case, ``ulimit`` needs to be modified/increased.
  To remove the limit, set ``ulimit -s unlimited``.
  See :ghdlsharp:`1112`.

  * In Python (say, when using VUnit or cocotb), the stack size can be increased by using the `resource module`_.
    For example ``resource.setrlimit(resource.RLIMIT_STACK, (resource.RLIM_INFINITY, resource.RLIM_INFINITY))``.

.. _resource module: https://docs.python.org/3/library/resource.html#resource.setrlimit

* The size of objects is supposed to be limited to 4GB.
  However, users finding the limit might get different constraints, depending on the backend. See :ghdlsharp:`822`.

* Waveform buffering can prevent the last cycles being flushed when a foreign subprogram is executed.
  Use ``fflush(NULL);`` at the beginning of the foreign subprogram.
  See :ghdlsharp:`1855`.
