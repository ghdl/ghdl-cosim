#!/usr/bin/env sh

set -e

cd $(dirname "$0")


echo "> Analyze tb.vhd"
ghdl -a tb.vhd


echo "> Build tb pass (with main.c)"
ghdl -e -Wl,caux.c -Wl,main.c -o tb_pass tb pass

echo "> Execute tb_pass"
./tb_pass
echo $?
echo ""


echo "> Build tb fail (with main.c)"
ghdl -e -Wl,caux.c -Wl,main.c -o tb_fail tb fail

set +e

echo "> Execute tb_fail"
./tb_fail
echo $?
echo ""

set -e


echo "> Build tb pass_sigabrt (with main_sigabrt.c)"
ghdl -e -Wl,caux.c -Wl,main_sigabrt.c -o tb_pass_sigabrt tb pass

echo "> Execute tb_pass_sigabrt"
./tb_pass_sigabrt
echo $?
echo ""


echo "> Build tb fail_sigabrt (with main_sigabrt.c)"
ghdl -e -Wl,caux.c -Wl,main_sigabrt.c -o tb_fail_sigabrt tb fail

set +e

echo "> Execute tb_fail_sigabrt"
./tb_fail_sigabrt
echo $?
echo ""

set -e


echo "> Analyze --std=08 tb.vhd"
ghdl -a --std=08 tb.vhd


echo "> Build --std=08 tb pass (with main.c)"
ghdl -e --std=08 -Wl,caux.c -Wl,main.c -o tb_pass08 tb pass

echo "> Execute tb_pass08"
./tb_pass08
echo $?
echo ""


echo "> Build --std=08 tb fail (with main.c)"
ghdl -e --std=08 -Wl,caux.c -Wl,main.c -o tb_fail08 tb fail

set +e

echo "> Execute --std=08 tb_fail08"
./tb_fail08
echo $?
echo ""

set -e


echo "> Build --std=08 tb pass (with main_sigabrt.c)"
ghdl -e --std=08 -Wl,caux.c -Wl,main_sigabrt.c -o tb_pass08_sigabrt tb pass

echo "> Execute tb_pass08_sigabrt"
./tb_pass08_sigabrt
echo $?
echo ""


echo "> Build --std=08 tb fail (with main_sigabrt.c)"
ghdl -e --std=08 -Wl,caux.c -Wl,main_sigabrt.c -o tb_fail08_sigabrt tb fail

set +e

echo "> Execute --std=08 tb_fail08_sigabrt"
./tb_fail08_sigabrt
echo $?
echo ""

set -e
