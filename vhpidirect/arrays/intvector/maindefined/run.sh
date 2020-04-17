#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Build main.o (with caux.h) [GCC]"
gcc -c main.c

echo "Analyze tb.vhd [GHDL]"
ghdl -a tb.vhd

echo "Build tb (with caux.c) [GHDL]"
ghdl -e -Wl,main.o -Wl,caux.c tb

echo "Execute tb"
./tb
