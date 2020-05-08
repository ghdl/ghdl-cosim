#!/usr/bin/env sh

set -e

cd $(dirname "$0")


echo "VHDL 93: Analyze pkg_93.vhd ent.vhd tb.vhd"
ghdl -a --std=93 pkg_93.vhd ent.vhd tb.vhd

echo "Build tb_93 with caux.c"
ghdl -e --std=93 -Wl,caux.c -o tb_93 tb

echo "Execute tb_93"
./tb_93

echo "Clean tb_93"
rm work-obj*.cf tb_93 *.o
echo ""


echo "VHDL 08 -frelaxed: Analyze pkg_93.vhd ent.vhd tb.vhd"
ghdl -a --std=08 -frelaxed pkg_93.vhd ent.vhd tb.vhd

echo "Build tb_08relaxed with caux.c"
ghdl -e --std=08 -frelaxed -Wl,caux.c -o tb_08relaxed tb

echo "Execute tb_08relaxed"
./tb_08relaxed

echo "Clean tb_08relaxed"
rm work-obj*.cf tb_08relaxed *.o
echo ""


echo "VHDL 08: Analyze pkg_08.vhd ent.vhd tb.vhd"
ghdl -a --std=08 pkg_08.vhd ent.vhd tb.vhd

echo "Build tb_08 with caux.c"
ghdl -e --std=08 -Wl,caux.c -o tb_08 tb

echo "Execute tb_08"
./tb_08

echo "Clean tb_08"
rm work-obj*.cf tb_08 *.o
echo ""


echo "VHDL 93: Analyze shint/pkg.vhd shint/ent.vhd tb.vhd"
ghdl -a shint/pkg.vhd shint/ent.vhd tb.vhd

echo "Build tb_93shint with caux.c"
ghdl -e -Wl,shint/caux.c -o tb_93shint tb

echo "Execute tb_93shint"
./tb_93shint

echo "Clean tb_93shint"
rm work-obj*.cf tb_93shint *.o
echo ""


echo "VHDL 08: Analyze shint/pkg.vhd shint/ent.vhd tb.vhd"
ghdl -a --std=08 shint/pkg.vhd shint/ent.vhd tb.vhd

echo "Build tb_08shint with caux.c"
ghdl -e --std=08 -Wl,shint/caux.c -o tb_08shint tb

echo "Execute tb_08shint"
./tb_08shint

echo "Clean tb_08shint"
rm work-obj*.cf tb_08shint *.o


echo "VHDL 93: Analyze shrecord/pkg.vhd shrecord/ent.vhd tb.vhd"
ghdl -a shrecord/pkg.vhd shrecord/ent.vhd tb.vhd

echo "Build tb_93shrecord with caux.c"
ghdl -e -Wl,shrecord/caux.c -o tb_93shrecord tb

echo "Execute tb_93shrecord"
./tb_93shrecord

echo "Clean tb_93shrecord"
rm work-obj*.cf tb_93shrecord *.o
echo ""


echo "VHDL 08: Analyze shrecord/pkg.vhd shrecord/ent.vhd tb.vhd"
ghdl -a --std=08 shrecord/pkg.vhd shrecord/ent.vhd tb.vhd

echo "Build tb_08shrecord with caux.c"
ghdl -e --std=08 -Wl,shrecord/caux.c -o tb_08shrecord tb

echo "Execute tb_08shrecord"
./tb_08shrecord

echo "Clean tb_08shrecord"
rm work-obj*.cf tb_08shrecord *.o