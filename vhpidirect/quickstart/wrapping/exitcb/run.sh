#!/usr/bin/env sh

set -e

cd $(dirname "$0")

_ext='so'
case "$(uname)" in
  MINGW*) _ext='dll';;
esac

for std in '08' '93'; do

  echo "> [$std] Analyze tb.vhd"
  ghdl -a --std="$std" tb.vhd

  echo ""

  for item in 'pass' 'fail'; do
    echo "> [$std] Build tb-${item}"
    ghdl -e --std="$std" -Wl,-fPIC -Wl,caux.c -Wl,main.c tb ${item}
    echo ""

    echo "> [$std]Run tb-${item}"
    ./tb-"${item}"
    echo ""
  done

done
