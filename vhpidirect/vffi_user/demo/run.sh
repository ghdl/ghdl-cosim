#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a --std=08 -O0 -g tb.vhd

echo "Build tb (with main.c and headers)"
ghdl -e --std=08 -O0 -g -Wl,-I../../ -Wl,main.c tb

echo "Execute tb"
./tb
