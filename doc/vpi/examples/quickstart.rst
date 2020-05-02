.. program:: ghdl
.. _COSIM:VPI:Examples:quickstart:

Quick Start
###########

.. _COSIM:VPI:Examples:quickstart:hello:

:cosimtree:`hello <vpi/quickstart/vpi_hello.c>`
***********************************************

This is the most minimal example, where a single callback is registered at the beginning of the simulation. The callback just
prints ``Hello!``. Then, the simulation is executed as usual.

VPI allows to register callbacks at multiple events and to optionally delay their execution after the event is triggered.
The list of available callback reasons is defined in :ghdlsrc:`vpi_user.h <grt/vpi_user.h>`. The structure type that is used
and required to register a callback, ``s_cb_data``, is also defined in the same header file.
