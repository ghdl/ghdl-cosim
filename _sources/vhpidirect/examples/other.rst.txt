.. _COSIM:VHPIDIRECT:Examples:other:

Other co-simulation projects
############################

This section contains references to other co-simulation projects based on GHDL and VHPIDIRECT.


ghdlex and netpp
================

`netpp (network property protocol) <https://section5.ch/index.php/netpp/>`_ is a communication library allowing to expose
variables or other properties of an application to the network as abstract 'Properties'. Its basic philosophy is that a
device always knows its capabilities. netpp capable devices can be explored by command line, Python scripts or GUI applications.
Properties of a device - be it virtual or real - are typically described by a static description in an XML device description
language, but they can also be constructed on the fly.

`ghdlex <https://github.com/hackfin/ghdlex>`_ is a set of C extensions to facilitate data exchange between a GHDL simulation
and external applications. VHPIDIRECT mechanisms are used to wrap GHDL data types into structures usable from a C library.
`ghdlex` uses the `netpp <https://section5.ch/index.php/netpp/>`_ library to expose virtual entities (such as pins or RAM)
to the network. It also demonstrates simple data I/O through unix pipes. A few VHDL example entities are provided, such as
a virtual console, FIFOs, RAM.

The author of `netpp` and `ghdlex` is also working on `MaSoCist <https://github.com/hackfin/MaSoCist>`_, a linux'ish build
system for System on Chip designs, based on GHDL. It allows to handle more complex setup, e.g. how a RISC-V architecture
(for example) is regress-tested using a virtual debug interface.


VUnit
=====

`VUnit <https://github.com/VUnit/vunit>`_ is an open source unit testing framework for VHDL/SystemVerilog. Sharing memory
buffers between foreign C or Python applications and VHDL testbenches is supported through GHDL's VHPIDIRECT features.
Buffers are accessed from VHDL as either strings, arrays of bytes or arrays of 32 bit integers. See
`VUnit/cosim <https://github.com/VUnit/cosim>`_ for details about the API.


ygdes.com
=========

Yann Guidon is a many-hack who tried to push GHDL's VHPIDIRECT over the edge in a series of articles around 2010 (as
you can read this, GHDL recovered very well since).

GHDL is an essential tool to design Free HW designs and Yann is still trying to hack it beyond its intended scope, to
fill voids in the Free Software landscape that keep him from designing more microprocessor cores.
He is mostly active on Hackaday.io (`hackaday.io/whygee <https://hackaday.io/whygee>`_) and working on converging
projects such as:

* The YGREC8 microcontroller core: `ygrec8.com <http://ygrec8.com>`_.
* An embedded webserver for co-simulations: `micro HTTP server in C <https://hackaday.io/project/20042-micro-http-server-in-c>`_.
* A VHDL library of gates that doubles as other verification tool (including hopefully an Automatic Test Pattern Generator):
  `VHDL library for gate-level verification <https://hackaday.io/project/162594-vhdl-library-for-gate-level-verification>`_.
