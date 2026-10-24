.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:grt:

GRT
###

.. _COSIM:VHPIDIRECT:Examples:grt:step:

:cosimtree:`step <vhpidirect/grt/step>`
***************************************

As explained in :ref:`COSIM:VHPIDIRECT:Wrapping:Step`, GHDL allows executing simulations step by step when wrapped in a
foreign language. This is a minimal showcase.

The testbench in this example is a single process that prints a message 10 times, every ``10 ns``; then it waits indefinitely.
The wrapper uses a ``do {} while`` loop for printing the return code of each step. If/when the return code is ``>2``, the
simulation is either finished or stopped, so the program exits.
