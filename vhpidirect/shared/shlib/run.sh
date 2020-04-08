#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a tb.vhd

echo "Build lib.so [GCC]"
gcc -shared lib.c -o lib.so

echo "Build tb [GHDL]"
ghdl -e tb

echo "Execute tb"
./tb
