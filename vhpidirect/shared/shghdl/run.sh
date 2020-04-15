#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "> Analyze tb.vhd"
ghdl -a tb.vhd

echo "> Build main.c"
gcc main.c -o main -ldl

#---

echo "> Build and execute [GHDL]"
ghdl -e -Wl,test.c -Wl,-Wl,--version-script=./test.ver -o tb.so tb
./main

echo "> Build and execute [GHDL -shared]"
ghdl -e -Wl,test.c -shared -o tb.so tb
./main

echo "> Build and execute [GHDL -Wl,-shared]"
ghdl -e -Wl,test.c -Wl,-shared -Wl,-Wl,--version-script=./test.ver -Wl,-Wl,-u,ghdl_main -o tb.so tb
./main

echo "> Bind tb"
ghdl --bind tb

echo "> Build and execute [GCC -shared]"
gcc test.c -shared -Wl,`ghdl --list-link tb` -Wl,--version-script=./test.ver -Wl,-u,ghdl_main -o tb.so
./main
