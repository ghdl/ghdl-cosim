#!/usr/bin/env sh

cd "$(dirname $0)"

set -e

echo "> Analyze vffi_pkg"
ghdl -a --std=08 --work=ghdl ../../vffi_user.vhd ../../vffi_user-body.vhd

echo "> Analyze c/tb.vhd"
ghdl -a --std=08 c/tb.vhd

echo "> Build tb_c (with encrypt.c and c/caux.c)"
ghdl -e --std=08 -Wl,-I../.. -Wl,encrypt.c -Wl,c/caux.c -o tb_c -Wl,-lcrypto -Wl,-lssl tb

echo "> Execute tb_c"
set +e
./tb_c
set -e
