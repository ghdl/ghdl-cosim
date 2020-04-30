#!/usr/bin/env sh

set -e

cd "$(dirname $0)"

echo "Analyze ent.vhd"
ghdl -a ent.vhd

echo "Elaborate tb"
ghdl -e ent

echo "Compile vpi.c"
ghdl --vpi-compile gcc -c vpi.c -I./../../ -o vpi.o

echo "Link vpi.o"
ghdl --vpi-link gcc vpi.o -o vpi.vpi

echo "Execute ent"
ghdl -r ent --vpi=./vpi.vpi
