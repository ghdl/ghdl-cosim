<p align="center">
  <a title="Read the Docs" href="http://ghdl.readthedocs.io/en/latest/using/Synthesis.html"><img src="https://img.shields.io/readthedocs/ghdl.svg?longCache=true&style=flat-square&logo=read-the-docs&logoColor=e8ecef&label=ghdl.rtfd.io"></a><!--
  -->
  <a title="Site" href="https://ghdl.github.io/ghdl-cosim"><img src="https://img.shields.io/website.svg?label=ghdl.github.io%2Fghdl-cosim&longCache=true&style=flat-square&url=http%3A%2F%2Fghdl.github.io%2Fghdl-cosim%2Findex.html"></a><!--
  -->
  <a title="Join the chat at https://gitter.im/ghdl1/Lobby" href="https://gitter.im/ghdl1/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge"><img src="https://img.shields.io/badge/chat-on%20gitter-4db797.svg?longCache=true&style=flat-square&logo=gitter&logoColor=e8ecef"></a><!--
  -->
  <a title="'test' workflow status" href="https://github.com/ghdl/ghdl-cosim/actions?query=workflow%3Atest"><img alt="'test' workflow status" src="https://img.shields.io/github/workflow/status/ghdl/ghdl-cosim/test?longCache=true&style=flat-square&label=test&logo=github"></a><!--
  -->
  <a title="'doc' workflow status" href="https://github.com/ghdl/ghdl-cosim/actions?query=workflow%3Adoc"><img alt="'doc' workflow status" src="https://img.shields.io/github/workflow/status/ghdl/ghdl-cosim/doc?longCache=true&style=flat-square&label=doc&logo=github"></a><!--
  -->
</p>

# Co-simulation with GHDL

This repository contains **documentation** with code **examples** about different procedures to interface VHDL with foreign languages and tools through GHDL.

Subdirs in [vhpidirect](./vhpidirect) and [vpi](./vpi) contain groups of examples to illustrate specific sets of features. Run the
`run.sh` script in each subdir in order to build and execute the group of examples. In some cases, there are further subdirs with
additional examples. Explanations are available in the [docs](https://ghdl.github.io/ghdl-cosim).

*This repository was created recently and multiple existing examples are not published yet. Find on-going work in issue [#1](https://github.com/ghdl/ghdl-cosim/issues/1) and in [open Pull Requests](https://github.com/ghdl/ghdl-cosim/pulls)*.

## Makefiles

### Brief refresher

The first rule in each makefile is the default rule executed, `afresh` will clean and then run. This is triggered by calling `make`.

All makefile rules can be called by specifying the target (argument left of the rule's ':') after make: e.g. `make run`

Make echoes each command before executing it, unless the line starts with `@`. All lines are echoed to the terminal, excepting `echo` calls.
This provides transparency on the commans being executed.

### Symbols used

The symbols below are used in order to make it easy to create a consistent change in the make operation.

- `CC?=gcc`, `CFLAGS+=-fPIC`
  - These determine which C compiler is used and the flags that are issued with it.
- `GHDL?=ghdl`, `STD?=93`
  - These determine the GHDL executable called and the VHDL standard used.
