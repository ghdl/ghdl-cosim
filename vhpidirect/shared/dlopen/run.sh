#!/usr/bin/env sh

set -e

cd $(dirname "$0")

echo "Build corea.so"
gcc -fPIC -shared corea.c -o corea.so

echo "Build coreb.so"
gcc -fPIC -shared coreb.c -o coreb.so

echo "Build main"
gcc main.c -o main -ldl

echo "Execute main"
./main
