.. program:: ghdl
.. _COSIM:CI:

Continuous Integration
######################

Since the main purpose of this repository is to provide reproducible and documented examples for users to learn, all of
them are tested periodically in a `Continuous Integration (CI) <https://en.wikipedia.org/wiki/Continuous_integration>`_
service. Currently, `GitHub Actions <https://github.com/features/actions>`_ is used and four different jobs/environments
are tested:

* GNU/Linux:

    * Docker image ``ghdl/vunit:llvm`` from `ghdl/docker <https://github.com/ghdl/docker>`_.
    * Latest *nightly* release installed through Action `ghdl/setup-ghdl-ci <https://github.com/ghdl/setup-ghdl-ci>`_ on
      Ubuntu.

* Windows:

    * Latest stable release for MINGW64 with LLVM backend.
    * Latest *nightly* release installed through Action `ghdl/setup-ghdl-ci <https://github.com/ghdl/setup-ghdl-ci>`_ on
      MINGW64.

    .. NOTE::
       MSYS2 is set up with Action `msys2/setup-msys2 <https://github.com/msys2/setup-msys2>`_.

The entrypoints of the examples are shell scripts (``run.sh``), makefiles (see :cosimsharp:`24`), or Python scripts
(``run.py``). To handle all of them with a common interface, `pytest <https://pytest.org>`_ is used. Hence the full test suite
is defined in :cosimtree:`test.py <test.py>`. Details about which examples are not supported on specific platforms can
be found there.

Past runs can be inspected at `ghdl/ghdl-cosim/actions <https://github.com/ghdl/ghdl-cosim/actions?query=workflow%3Atest>`_.
It can be useful for users to know what to expect before executing the examples themselves.
