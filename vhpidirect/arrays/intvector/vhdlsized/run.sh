#!/usr/bin/env sh

set -e

cd $(dirname "$0")

for arch in 'calloc' 'vhdlallocarr' 'vhdlallocacc'; do

echo "> Analyze pkg.vhd and tb.vhd"
ghdl -a pkg.vhd tb.vhd

echo "> Build tb_$arch (with caux.c) [GHDL]"
ghdl -e -Wl,caux.c -o tb_"$arch" tb "$arch"

echo "> Execute tb_$arch"
./tb_"$arch"

echo ""

done
