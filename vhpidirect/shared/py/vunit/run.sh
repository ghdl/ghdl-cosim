#!/usr/bin/env sh

set -e

cd $(dirname "$0")

for std in '2008' '93'; do
  export VUNIT_VHDL_STANDARD="$std"

  echo "> [$std] VUnit compile"
  if ! $(python3 run.py --compile > vunit.log 2>&1); then
    cat vunit.log;
  fi
  echo ""

  echo "> [$std] VUnit run"
  python3 run.py -v
  echo ""

  echo "> [$std] VUnit cosim"
  PYTHONPATH=$(pwd)/.. python3 cosim.py
  echo ""
done
