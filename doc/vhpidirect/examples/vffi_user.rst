.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:cinterface:

FFI/DPI Header
##############

As explained in :ref:`COSIM:VHPIDIRECT:Declarations`, some VHDL types are exposed as fat pointers. Hence, dealing with unconstrained
arrays and accesses might be cumbersome. :cosimtree:`vffi_user.h <vhpidirect/vffi_user.h>` is a utily C header file for easing
the usage of those complex types. The examples in this section showcase the usage of ``vffi_user.h``.

.. ATTENTION:: As explained in the :ref:`home page <COSIM>`, GHDL's implementation of VHPIDIRECT is not compliant with the standard,
  and the standarization of a FFI/DPI is being discussed in the VASG (see `[LCS-202x] VHDL DPI/FFI based on GHDL’s implementation of VHPIDIRECT <https://umarcor.github.io/ghdl-cosim/vhdl202x/index.html>`_).
  The ``vffi_user.h`` file available in this repo corresponds to the current implementation in GHDL. As the standarization process
  goes forward, GHDL is expected to be adapted. Therefore, users should expect probably breaking changes in the header file.

:cosimtree:`demo <vhpidirect/vffi_user/demo>`
*********************************************

This is a synthetic example that uses all the supported/defined data types and the helper functions in ``vffi_user.h`` for converting
fat pointers to sets of C types. Hence, it is a regression test for the header file.
