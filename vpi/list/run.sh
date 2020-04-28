#!/bin/sh
ghdl -a adder.vhd adder_tb.vhd
ghdl -e adder_tb
ghdl --vpi-compile gcc -c vpi.c -I./../common/ -o vpi.o
ghdl --vpi-link gcc vpi.o -o vpi.vpi
ghdl -r adder_tb --vpi=./vpi.vpi
