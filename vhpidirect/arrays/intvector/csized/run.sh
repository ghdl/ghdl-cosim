#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "> fcn!"
./fcn/run.sh

echo "> proc!"
./proc/run.sh
