#!/usr/bin/env sh

set -e

cd $(dirname "$0")

PY="python3"
if ! command -v "$PY"; then
  PY="python"
fi

echo "> Build caux.so"
gcc -fPIC -shared caux.c -o caux.so

echo "> Execute run.py"
$PY run.py

cd pyghdl

echo "> Analyze tb.vhd"
ghdl -a tb.vhd

echo "> Build caux.so [GHDL -shared]"
#ghdl -e -Wl,-fPIC -Wl,caux.c -shared -o caux.so tb
ghdl -e -Wl,-fPIC -Wl,caux.c -Wl,-shared -Wl,-Wl,--version-script=./test.ver -Wl,-Wl,-u,ghdl_main -o caux.so tb

echo "> Execute run.py"
$PY ../run.py
