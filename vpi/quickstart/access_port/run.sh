#!/usr/bin/env sh

set -e

cd "$(dirname $0)"

PATH=$PATH:$(pwd)

echo "Analyze tb.vhd"
ghdl -a tb.vhd

echo "Elaborate tb"
ghdl -e tb

echo "Compile vpi.c"
ghdl --vpi-compile gcc -c vpi.c -I./../../ -o vpi.o

echo "Link vpi.o"
ghdl --vpi-link gcc vpi.o -o vpi.vpi

echo "Execute tb"
ghdl -r tb --vpi=./vpi.vpi
