#!/usr/bin/env sh

set -e

cd $(dirname "$0")

for std in '08' '93'; do

echo "> [$std] Analyze tb.vhd"
ghdl -a --std="$std" tb.vhd


echo "> [$std] Build tb pass"
ghdl -e --std="$std" -Wl,caux.c -Wl,main.c -o tb"$std"_pass tb pass

echo "> [$std] Execute tb_pass"
./tb"$std"_pass
echo $?
echo ""


echo "> [$std] Build tb-pass.so"
ghdl -e --std="$std" -shared -Wl,-fPIC -Wl,caux.c -Wl,main.c tb pass
mv tb-pass.so tb-fail.so
echo ""

set +e

echo "> [$std] Python cosim pass"
python3 py/cosim.py
echo ""

set -e


echo "> [$std] Build tb fail"
ghdl -e --std="$std" -Wl,caux.c -Wl,main.c -o tb"$std"_fail tb fail

set +e

echo "> [$std] Execute tb_fail"
./tb"$std"_fail
echo $?
echo ""

set -e


echo "> [$std] Build tb-fail.so"
ghdl -e --std="$std" -shared -Wl,-fPIC -Wl,caux.c -Wl,main.c tb fail
echo ""

set +e

echo "> [$std] Python cosim fail"
python3 py/cosim.py
echo ""

set -e


echo "> [$std] Build tb pass_sigabrt"
ghdl -e --std="$std" -Wl,caux.c -Wl,main_sigabrt.c -o tb"$std"_pass_sigabrt tb pass

echo "> [$std] Execute tb_pass_sigabrt"
./tb"$std"_pass_sigabrt
echo $?
echo ""

set -e


echo "> [$std] Build tb-pass.so (sigabrt)"
ghdl -e --std="$std" -shared -Wl,-fPIC -Wl,caux.c -Wl,main_sigabrt.c tb pass
mv tb-pass.so tb-fail.so
echo ""

set +e

echo "> [$std] Python cosim pass (sigabrt)"
python3 py/cosim.py
echo ""

set -e


echo "> [$std] Build tb fail_sigabrt)"
ghdl -e --std="$std" -Wl,caux.c -Wl,main_sigabrt.c -o tb"$std"_fail_sigabrt tb fail

set +e

echo "> [$std] Execute tb_fail_sigabrt"
./tb"$std"_fail_sigabrt
echo $?
echo ""

set -e

echo "> [$std] Build tb-fail.so (sigabrt)"
ghdl -e --std="$std" -shared -Wl,-fPIC -Wl,caux.c -Wl,main_sigabrt.c tb fail
echo ""

set +e

echo "> [$std] Python cosim fail (sigabrt)"
python3 py/cosim.py
echo ""

set -e

done
