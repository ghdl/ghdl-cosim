#!/usr/bin/env sh

set -e

cd $(dirname "$0")

if command -v apt; then
  $(command -v sudo) apt update -qq
  $(command -v sudo) apt install -y imagemagick
fi;

if ! command -v convert; then
  echo "This example requires 'convert' from 'imagemagick!"
  exit 1
fi;

echo "> Analyze pkg.vhd and tb.vhd"
ghdl -a --std=08 -frelaxed pkg.vhd tb.vhd

echo "> Build tb_test (with caux.c)"
ghdl -e --std=08 -frelaxed -Wl,caux.c -o tb_test tb test

echo "> Execute tb_test"
./tb_test

echo "> Build tb_bars (with caux.c)"
ghdl -e --std=08 -frelaxed -Wl,caux.c -o tb_bars tb bars

echo "> Execute tb_bars"
./tb_bars

if [ -n "$DISPLAY" ]; then
  echo "> Build tb_testX11 (with caux_x11.c)"
  ghdl -e --std=08 -frelaxed -Wl,caux_x11.c -Wl,-lX11 -o tb_testX11 tb test

  echo "> Execute tb_testX11"
  ./tb_testX11
fi
