#!/usr/bin/env sh

set -e

echo "Analyze ent.vhd"
ghdl -a ent.vhd

echo "Elaborate tb"
ghdl -e ent

echo "Compile vpi.c"
ghdl --vpi-compile gcc -c vpi.c -I./../common/ -o vpi.o

echo "Link vpi.o"
ghdl --vpi-link gcc vpi.o -o vpi.vpi

echo "Execute ent"
ghdl -r ent --vpi=./vpi.vpi
