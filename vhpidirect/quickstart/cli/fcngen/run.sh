#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "> Analyze tb.vhd and arch.vhd"
ghdl -a ../tb.vhd
ghdl -a arch.vhd

echo "> Build tb (with main.c)"
ghdl -e -Wl,main.c -o tb tb

echo "> Execute tb"
./tb

echo "> Execute tb with CLI arg"
./tb -ggenInt=17
