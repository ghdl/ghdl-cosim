#!/usr/bin/env sh

set -e

cd $(dirname "$0")

_os='linux'
case "$(uname)" in
  MINGW*) _os='windows';;
esac

echo "Analyze tb.vhd"
ghdl -a tb.vhd

#---

echo "Build tb (with main.c) [GHDL]"
ghdl -e -Wl,main.c -o tb_c tb

echo "Execute tb_c"
./tb_c

# OR

echo "Build main.c"
gcc -c main.c

echo "Build tb (with main.o) [GHDL]"
ghdl -e -Wl,main.o -o tb_o tb

echo "Execute tb_o"
./tb_o

# OR

if [ "x${_os}" != "xwindows" ]; then
  # FIXME: This should work on MSYS2, but the output of '--list-link' is broken.
  # The returned paths contain mixed '\' and '/'.

  echo "Bind tb"
  ghdl --bind tb

  echo "Build tb (with main.c) [GCC]"
  gcc main.c -Wl,`ghdl --list-link tb` -o tb_lc

  echo "Execute tb_lc"
  ./tb_lc

  # OR

  echo "Build main.c"
  gcc -c main.c

  echo "Bind tb"
  ghdl --bind tb

  echo "Build tb (with main.o) [GCC]"
  gcc main.o -Wl,`ghdl --list-link tb` -o tb_lo

  echo "Execute tb_lo"
  ./tb_lo

fi
