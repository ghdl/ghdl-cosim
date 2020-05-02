.. program:: ghdl
.. _COSIM:VPI:Examples:

Examples
########

A very brief description of how to use VPI is that ``vpi_user.h`` provides dozens of functions to scan/navigate the hierarchy
of the elaborated hardware design, and it allows to set callbacks for specific events/signals.

.. NOTE::
  Since VHDL sources are agnostic to the usage of VPI modules, most of the examples in this section reuse the same VHDL
  sources. Readers should focus on the differences between the provided C files.

.. ATTENTION::
  On Windows, the directory containing ``libghdlvpi.dll`` needs to be added to the ``PATH``. This can be achieved with
  :option:`--vpi-library-dir`, :option:`--vpi-library-dir-unix` or ``$(cd $(dirname $(which ghdl))/../lib; pwd)``.

.. toctree::

   quickstart
