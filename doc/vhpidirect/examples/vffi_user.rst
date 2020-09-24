.. program:: ghdl
.. _COSIM:VHPIDIRECT:Examples:cinterface:

FFI/DPI Header
##############

As explained in :ref:`COSIM:VHPIDIRECT:Declarations`, some VHDL types are exposed as fat pointers. Hence, dealing with unconstrained
arrays and accesses might be cumbersome. At the same time, indexes of arrays with bounds of direction ``downto`` are reversed,
``std_logic`` values correspond to an specific enumeration, etc. :cosimtree:`vffi_user.h <vhpidirect/vffi_user.h>` is a utily
C header file for easing the usage of those complex types. The examples in this section showcase the usage of ``vffi_user.h``.
These examples are based on the foundations shown in previous examples. Hence, reading those is strongly suggested for understanding
the implementation details.

.. ATTENTION:: As explained in the :ref:`home page <COSIM>`, GHDL's implementation of VHPIDIRECT is not compliant with the standard,
  and the standarization of a FFI/DPI is being discussed in the VASG (see `[LCS-202x] VHDL DPI/FFI based on GHDL’s implementation of VHPIDIRECT <https://umarcor.github.io/ghdl-cosim/vhdl202x/index.html>`_).
  The ``vffi_user.h`` file available in this repo corresponds to the current implementation in GHDL. As the standarization process
  goes forward, GHDL is expected to be adapted. Therefore, users should expect probably breaking changes in the header file.


:cosimtree:`demo <vhpidirect/vffi_user/demo>`
*********************************************

This is a synthetic example that uses all the supported/defined data types and the helper functions in ``vffi_user.h`` for converting
fat pointers to sets of C types. Hence, it is a regression test for the header file.


:cosimtree:`xyce <vhpidirect/vffi_user/xyce>`
*********************************************

..

    "*Xyce is an open source, SPICE-compatible, high-performance analog circuit simulator, capable of solving extremely
    large circuit problems by supporting large-scale parallel computing platforms.
    It also supports serial execution on all common desktop platforms, and small-scale parallel runs on Unix-like
    systems*".

    -- `xyce.sandia.gov <https://xyce.sandia.gov>`_

Xyce provides two mechanisms for external tools/simulation codes to use it:

**General External Interface (GenExt)**
  Comprenhensive interface aimed at developers who wish to couple other external codes written in C++. See AppNote
  `Coupled Simulation with the Xyce General External Interface <https://xyce.sandia.gov/documentation/AppNote-GenExt.pdf>`_.

**Mixed Signal Interface (MixedSignal)**
  Interface to use Xyce as a shared library/object, either from C/C++ codes or through Python's ``ctypes``. Class
  `XyceCInterface <https://github.com/Xyce/Xyce/tree/master/utils/XyceCInterface>`_ provides methods to work with a
  pointer to the topmost object in a Xyce simulation; and corresponding Python bindings are provided. See AppNote
  `Mixed Signal Simulation with Xyce 6.11 <https://xyce.sandia.gov/downloads/_assets/documents/AppNote-MixedSignal_6.11.pdf>`_
  (other versions: `October 2018 <https://www.osti.gov/biblio/1483152-application-note-mixed-signal-simulation-xyce>`_, `June 2020 <https://xyce.sandia.gov/downloads/_assets/documents/AppNote-MixedSignal.pdf>`_).

Regarding integration with GHDL, both interfaces might be suitable for different targets:

* ``GenExt`` might allow GHDL to provide VHDL-AMS support to Xyce, as the interface allows Xyce to execute callbacks defined in
  a foreign tool. However, VHDL-AMS support in GHDL is incomplete. Currently, the parsing stage is implemented only. See
  :ghdlsharp:`1052`.
* ``MixedSignal`` provides a higher abstraction level mechanism, which allows for co-execution of otherwise atomic modules.

In this examples, a simplified C API based on ``MixedSignal`` is used. Moreover, VHDL bindings based on :cosimtree:`vffi_user.h <vhpidirect/vffi_user.h>`
are used for driving the co-simulation from VHDL. The main differences between this simplified API and ``XyceCInterface`` are:

* ``XyceCInterface`` is designed to use a variable of type ``void**`` as the handler of a simulation object.
  Unfortunately, such a type is not cleanly mapped to VHDL. Instead, identifiers of type `string` are used in VHDL,
  and this bridge provides a storage mechanism to keep track of the correspondence.
* VHDL's type system, which is based on Ada's, avoids the requirement of using additional function/procedure parameters
  for passing array constraints.

This simplified API is targeted at developers who use VHDL as the main language to orchestrate the co-execution. Hence,
existence of C sources is expected to be transparent. :ref:`xyce_pkg` provides the public VHDL API for end-users. Note that
it is possible to run multiple analog simulations by handling multiple instances of ``xyce_t`` from different VHDL
modules. Find usage details in :ref:`xyce_egs`.

.. note:: Currently, the C implementation is based on :cosimtree:`vffi_user.h <vhpidirect/vffi_user.h>`; hence, it is
  specific to GHDL. Nevertheless, it should be possible to adapt it for simulators that support FLI or XSI. Contributions
  are welcome!

.. note:: Although the C implementation is not expected to be used directly, it can be useful to access it when the
  simulation executable is to be dynamically loaded. In these contexts, it might be handy to initialize and close the Xyce
  simulations from, say, Python, while VHDL is used to run steps and handle I/O. Even though specific examples are not
  available yet, this is a supported use case.

.. note:: The current implementation of the storage mechanism is likely to be replaced as a result of the discussions
  in `VUnit/vunit#603 <https://github.com/VUnit/vunit/issues/603>`_. Such a replacement should be transparent to
  end-users. However, since this is a very experimental project yet, note that disruptive changes might be required.

.. _xyce_c:

Xyce: C interface
=================

This is a simplified API based on `XyceCInterface <https://github.com/Xyce/Xyce/tree/master/utils/XyceCInterface>`_. It
seems that binding ``void** ptr`` from C to VHDL is not supported. So, unconstrained strings are used instead. Unconstrained
strings can be accesed as ``char** id`` from C. A storage mechanism is used to manage actual pointers associated to each id
(string).

.. code-block:: c

    uint32_t xhdl_init(
      vffiNaturalDimArr_t* ptr,
      vffiNaturalDimArr_t* cir
    );

    uint32_t xhdl_run(
      vffiNaturalDimArr_t* ptr,
      double requestedUntilTime
    );

    uint32_t xhdl_run_1D(
      vffiNaturalDimArr_t* ptr,
      double requestedUntilTime,
      vffiNaturalDimArr_t* tArray,
      vffiNaturalDimArr_t* vArray
    );

    uint32_t xhdl_run_2D(
      vffiNaturalDimArr_t* ptr,
      double requestedUntilTime,
      vffiNaturalDimArr_t* array2D
    );

    double xhdl_read(
      vffiNaturalDimArr_t* ptr,
      vffiNaturalDimArr_t* name
    );

    void xhdl_close(
      vffiNaturalDimArr_t* ptr
    );

.. NOTE::
    Given the similarity between ``void**`` and ``char**`` (pointers), it might be possible to define a custom subtype of any
    type and use an access type to it as a placeholder for managing C void pointers in VHDL. To be investigated...

.. _xyce_vhdl:

Xyce: VHDL interface
====================

.. _xyce_pkg:

*xyce* package
--------------

Provides the user interface to co-execute Xyce simulations from VHDL. It is a protected type, which resembles OOP.

.. literalinclude:: ../../../vhpidirect/vffi_user/xyce/pkg/xyce_pkg.vhd
   :language: vhdl

.. _xyce_xhdl_pkg:

*xyce_xhdl* package
-------------------

Provides bindings between VHDL and a foreign language through VHPIDIRECT. This source needs to be included in the design, but users are not expected to use it explicitly.

.. literalinclude:: ../../../vhpidirect/vffi_user/xyce/pkg/xyce_xhdl_pkg.vhd
   :language: vhdl

.. _xyce_egs:

Examples
========

Xyce developers provide two versions of the same three examples (`utils/XyceCInterface <https://github.com/Xyce/Xyce/tree/master/utils/XyceCInterface>`_):

**Python_examples**
  Use ``xyce_interface.py`` to manage a Xyce simulation from Python. No HDL is used.

**VPI_examples**
  Use Verilog to trigger the Xyce simulations. However, all the logic is implemented in C.
  As explained in Section 7 of `Mixed Signal Simulation with Xyce 6.11 <https://xyce.sandia.gov/downloads/_assets/documents/AppNote-MixedSignal_6.11.pdf>`_:

      "*The primary issue with the VPI capability is the lack of standards compliance. The example (...) uses the C++
      features of the `XyceCInterface` directly. Wrapper functions, that only use ANSI C and the native PLI
      data-types in their function calls, still need to beimplemented.*"

The examples in this repo are an adaptation of the VPI_examples from Xyce's repo. Here, VHDL is used through VHPIDIRECT
bindings, instead of Verilog. The management of the execution flow is handled from VHDL, so that developers don't need to
code in C/C++. Regarding data types, native VHDL types are used. Precisely, unconstrained strings and unconstrained
``real_vector``.

:cosimtree:`runACircuit <vhpidirect/vffi_user/xyce/runACircuit>`
----------------------------------------------------------------

``runACircuit`` is the most simple use case, where a single VHDL test bench and a single C file are used. It shows how to
call Xyce from VHDL, but no data is passed and neither :ref:`xyce_c` nor :ref:`xyce_vhdl` are used.

.. NOTE:: Currently, ``XyceCInterface`` requires circuit models to be passed as a path to a file. Providing a pointer to a
  string or using ``stdin`` is not supported yet. However, the feature has been requested to developers of Xyce and
  it might be available in future versions.

:cosimtree:`runACircuitInSteps <vhpidirect/vffi_user/xyce/runACircuitInSteps>`
------------------------------------------------------------------------------

``runACircuitInSteps`` is based on :ref:`xyce_c` and :ref:`xyce_vhdl`. Precisely, ``xyce_t`` and
from :ref:`xyce_pkg` is used. This allows controlling the execution flow from VHDL, unlike ``runACircuit``
or the versions in Xyce's repo; where all the relevant logic is implemented in C and HDL is only used as a trigger.

.. NOTE:: See Section 7.1 of `Mixed Signal Simulation with Xyce 6.11 <https://xyce.sandia.gov/downloads/_assets/documents/AppNote-MixedSignal_6.11.pdf>`_
  for information regarding *known issues with coordinated timestepping*.

:cosimtree:`runWithDACs <vhpidirect/vffi_user/xyce/runWithDACs>`
----------------------------------------------------------------

``runWithDACs`` is also based on :ref:`xyce_c` and :ref:`xyce_vhdl`. On top of controlling the execution flow, in this example
DAC/ADC models provided by Xyce are used for passing data between the digital domain and the analog domain. So, the previous
two examples (``runACircuit`` and ``runACircuitInSteps``) are not proper digital/analog co-simulations, because there
is no communication between digital and analog domains. Those examples are provided for illustrative purposes only, as an
introduction to this one. Here, vectors containing voltage and time need to be passed from VHDL to C. Then, an a value from
the analog circuit is read and passed to VHDL. Two equivalent implementations/tests are shown:

* :cosimtree:`tb_xyce_eg_with_dacs_1D <vhpidirect/vffi_user/xyce/runWithDACs/tb_xyce_eg_with_dacs_1D.vhd>`: two `real_vector` variables are used for passing an array of time values and an array of voltage values as separate arguments. Checking that the length of both arrays match is done explicitly.
* :cosimtree:`tb_xyce_eg_with_dacs_2D <vhpidirect/vffi_user/xyce/runWithDACs/tb_xyce_eg_with_dacs_2D.vhd>`: a single multidimensional array of `real` is used for passing time and voltage values in a single argument. As a result, all the vectors are guaranteed to have the same length.

The behaviour of both tests is exactly the same. However, the 2D variant makes it easier to extend the example for handling multiple DACs. Overall, both cases are provided for illustrative purposes, as both 1D and 2D unconstrained arrays are fat pointers and helper functions from :cosimtree:`vffi_user.h <vhpidirect/vffi_user.h>` are used.

.. NOTE:: The YADC and YDAC device models in Xyce, are not realistic device models. Important issues like rise/fall times and
  drive/sink currents are not modelled. Hence, they are adequate for artificial transferring signal values between digital
  and analog domains, but those models need to be improved. See Section 5 of `Mixed Signal Simulation with Xyce 6.11 <https://xyce.sandia.gov/downloads/_assets/documents/AppNote-MixedSignal_6.11.pdf>`_.

Usage
-----

Two `VUnit <https://github.com/VUnit/vunit>`_ scripts are provided: :cosimtree:`run_minimal.py <vhpidirect/vffi_user/xyce/run_minimal.py>`
builds and executes ``runACircuit``, and :cosimtree:`run.py <vhpidirect/vffi_user/xyce/run.py>` takes care of the others.

Since Xyce's Mixed Signal Interface is an experimental feature yet, specific versions of the tools are required, and
configuration options need to be correctly chosen for producing shared libraries. In order to make getting a working
environment easier, a :cosimtree:`Dockerfile <docker/xyce.dockerfile>` is provided. Moreover, an image is built
periodically and published as `umarcor/cosim:xyce <https://hub.docker.com/r/umarcor/cosim/tags>`_.
The image is based on `ghdl/vunit:llvm-master <https://github.com/ghdl/docker>`_ and includes GHDL (``master``),
Python 3, VUnit (``master``) and Xyce.

.. NOTE:: In these examples, VUnit is used for automatic dependency scanning, incremental builds and unit testing only.
  Other features, such as communication libraries and verification components, are not used.

  Moreover, should :cosimtree:`vffi_user.h <vhpidirect/vffi_user.h>` be standardized (see `VHDL DPI/FFI based on GHDL
  <https://umarcor.github.io/ghdl-cosim/vhdl202x/index.html>`_), VUnit would allow testing multiple simulators easily.

.. NOTE:: As explained in AppNote `Digital/Analog Cosimulation using CocoTB and Xyce <https://www.osti.gov/biblio/1488489-digital-analog-cosimulation-using-cocotb-xyce>`_,
  cocotb can be used to co-simulate GHDL and Xyce through VPI, as an alternative to using VHPIDIRECT. Such an approach
  might be preferred when Python is to be used as the orchestrator. Moreover, the report introduces an interesting use
  case where digital and analog versions of the same module are used. Unfortunately, sources of that example are not
  publicly available.

GUI features
============

Neither GHDL nor Xyce provide built-in features for graphical schematic capture or plotting/viewing of simulation
signals. Fortunately, both of them support generating traces that can be visualised with specific free and open source
tools. If GHDL is used for generating waveforms, which might include digitalised analog signals, `GTKWave <http://gtkwave.sourceforge.net/>`_
can be used. Note that GTKWave provides an *analog* visualization type. Regarding Xyce, see AppNote `Using Open Source Schematic
Capture Tools With Xyce <https://xyce.sandia.gov/downloads/_assets/documents/AppNote-GedaAndXyce.pdf>`_ for information about
schematic capture and plotting tools. See also `Reading waveforms from HDL simulators with PulseView <https://github.com/umarcor/pulseview/tree/ghdl/ghdl>`_
and `Data type exploration and visualization in arithmetic algorithms/circuits <https://github.com/dbhi/fpconv>`_.

Analog modelling
================

Xyce supports Verilog-A through Automatic Device Model Synthesizer (ADMS), an open-source translator. Xyce/ADMS is a
set of XML templates for use with ADMS, which allows to emit C++ for a device model. See `Xyce/ADMS Users Guide <https://xyce.sandia.gov/documentation/XyceADMSGuide.html>`_.

Unfortunately, for VHDL-AMS there is neither built-in support nor a similar translation tool (yet). See related
discussion in `ghdl/ghdl#1052 <https://github.com/ghdl/ghdl/issues/1052>`_.
