#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a tb.vhd

echo "Build tb (with -lm)"
ghdl -e -Wl,-lm tb

echo "Execute tb"
./tb
