#!/usr/bin/env sh

cd $(dirname "$0")

export VUNIT_VHDL_STANDARD="2008"
python3 vunit_run.py -v
python3 vunit_cosim.py

export VUNIT_VHDL_STANDARD="93"
python3 vunit_run.py -v
python3 vunit_cosim.py
