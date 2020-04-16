#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a --std=08 -frelaxed pkg.vhd tb.vhd

echo "Build tb (with main.c)"
ghdl -e --std=08 -frelaxed -Wl,main.c tb

echo "Execute tb"
./tb
