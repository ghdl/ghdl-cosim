#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "> Analyze ent.vhd and tb.vhd"
ghdl -a ../ent.vhd ../tb.vhd

echo "> Elaborate tb"
ghdl -e -o tb tb

echo "> Compile vpi_hello.c"
ghdl --vpi-compile gcc -c vpi_hello.c -o vpi.o

echo "> Link vpi.o"
ghdl --vpi-link gcc vpi.o -o vpi.vpi

if [ "$OS" = "Windows_NT" ]; then
  # Need to put the directory containing libghdlvpi.dll in the path.
  PATH=$PATH:`ghdl --vpi-library-dir-unix`
fi

echo "> Execute tb"
./tb --vpi=./vpi.vpi
