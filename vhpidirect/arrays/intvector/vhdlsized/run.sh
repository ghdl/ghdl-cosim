#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a tb.vhd

echo "Build tb (with caux.c) [GHDL]"
ghdl -e -Wl,caux.c tb

echo "Execute tb (-gg_array_size=2)"
./tb -gg_array_size=2

echo "Execute tb (-gg_array_size=6)"
./tb -gg_array_size=6
