#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "! C alloc C sized:"
./csized/run.sh

echo ""

echo "! VHDL sized:"
./vhdlsized/run.sh
