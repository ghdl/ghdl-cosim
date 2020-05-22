#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Analyze tb.vhd"
ghdl -a tb.vhd

echo "Build tb (with main.c)"
ghdl -e -Wl,main.c tb

echo "Execute tb"
./tb

if which gnatmake && [ "x$1" = "xada" ]; then
  echo "Bind tb"
  ghdl --bind tb

  echo "Build tb_ada (with showtime)"
  gnatmake showtime -o tb_ada -largs `ghdl --list-link tb`

  echo "Execute tb_ada"
  ./tb_ada
fi
