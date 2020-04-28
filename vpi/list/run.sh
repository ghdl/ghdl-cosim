#!/usr/bin/env sh

set -e

cd "$(dirname $0)"

echo "Analyze ent.vhd and tb.vhd"
ghdl -a ent.vhd tb.vhd

echo "Elaborate tb"
ghdl -e tb

echo "Compile vpi.c"
ghdl --vpi-compile gcc -c vpi.c -I./../common/ -o vpi.o

echo "Link vpi.o"
ghdl --vpi-link gcc vpi.o -o vpi.vpi

echo "Execute tb"
ghdl -r tb --vpi=./vpi.vpi
