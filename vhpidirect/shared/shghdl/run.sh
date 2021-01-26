#!/usr/bin/env sh

set -e

cd $(dirname "$0")

_os='linux'
case "$(uname)" in
  MINGW*) _os='windows';;
esac

echo "> Analyze tb.vhd"
ghdl -a tb.vhd

echo "> Build main.c"
gcc main.c -o main -ldl

#---

if [ "x${_os}" != "xwindows" ]; then
  # This is hackish, since the generated file is an executable, not a shared library.
  # It might work on some platforms due to the similarities between ELF binaries and libs.
  echo "> Build and execute [GHDL]"
  ghdl -e -Wl,test.c -Wl,-Wl,--version-script=./test.ver -o tb.lib tb
  ./main

  # Custom function names are not exported/visible by default on some platforms.
  # This might work, but spicifying a custom '--version-script' is recommended (see below).
  echo "> Build and execute [GHDL -shared]"
  ghdl -e -Wl,test.c -shared -o tb.so tb
  ./main
fi

echo "> Build and execute [GHDL -Wl,-shared]"
ghdl -e -Wl,test.c -Wl,-shared -Wl,-Wl,--version-script=./test.ver -Wl,-Wl,-u,ghdl_main -o tb.lib tb
./main

if [ "x${_os}" != "xwindows" ]; then
  # FIXME: This should work on MSYS2. The problem is the paths returned by '--list-link',
  # which contain mixed '\' and '/'. See quickstart/linking/bind
  echo "> Bind tb"
  ghdl --bind tb

  echo "> Build and execute [GCC -shared]"
  gcc test.c -shared -Wl,`ghdl --list-link tb` -Wl,--version-script=./test.ver -Wl,-u,ghdl_main -o tb.lib
  ./main
fi
