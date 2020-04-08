#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a tb.vhd

echo "Build main.c"
gcc main.c -o main -ldl

echo "Build tb.so [GHDL]"
ghdl -e -Wl,-Wl,--version-script=../../vhpidirect.ver -o tb.so tb

echo "Execute main"
./main
