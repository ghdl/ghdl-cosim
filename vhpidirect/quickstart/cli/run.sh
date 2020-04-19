#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "> Analyze tb.vhd and arch.vhd"
ghdl -a tb.vhd
ghdl -a arch.vhd


echo "> Build tb"
ghdl -e -o tb tb

echo "> Execute tb"
./tb

echo "> Execute tb with CLI args"
./tb -ggenStr="custom message" -ggenInt=17


echo "> Build tb (with rawargs.c)"
ghdl -e -Wl,rawargs.c -o tb_rawargs tb

echo "> Execute tb_rawargs"
./tb_rawargs

echo "> Execute tb_rawargs with CLI args"
./tb_rawargs -ggenStr="custom message" -ggenInt=17


echo "> Build tb (with procargs.c)"
ghdl -e -Wl,procargs.c -o tb_procargs tb

echo "> Execute tb_procargs"
./tb_procargs

echo "> Execute tb_procargs with CLI arg"
./tb_procargs -ggenInt=17
