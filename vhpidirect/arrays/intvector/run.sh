#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a tb.vhd

echo "Build tb (with caux.c) [GHDL]"
ghdl -e -Wl,caux.c tb

echo "Execute tb"
./tb
