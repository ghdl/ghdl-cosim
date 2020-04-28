#!/bin/sh
ghdl -a adder.vhd
ghdl -e adder
ghdl --vpi-compile gcc -c vpi.c -I./../common/ -o vpi.o
ghdl --vpi-link gcc vpi.o -o vpi.vpi
ghdl -r adder --vpi=./vpi.vpi
