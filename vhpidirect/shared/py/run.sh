#!/usr/bin/env sh

set -e

cd $(dirname "$0")

_exitcbdir='../../quickstart/wrapping/exitcb'

_ext='so'
case "$(uname)" in
  MINGW*) _ext='dll';;
esac

for std in '08' '93'; do

  echo "> [$std] Analyze tb.vhd"
  ghdl -a --std="$std" "${_exitcbdir}"/tb.vhd

  echo ""

  for item in 'pass' 'fail'; do
    echo "> [$std] Build tb-${item}.${_ext}"
    ghdl -e --std="$std" -shared -Wl,-fPIC -Wl,"${_exitcbdir}"/main.c tb ${item}
    echo ""

    echo "> [$std] Python load and run tb-${item}.${_ext}"
    PYTHONPATH=$(pwd) python3 -c 'from pyaux import run; run("./tb-'"${item}.${_ext}"'", 0, None)'
    echo ""
  done

done
