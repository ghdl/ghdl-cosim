from pyaux import dlopen, dlclose, enc_args, run
from pathlib import Path
from json import load

print("PY COSIM ENTER")

with (Path(__file__).parent / 'vunit_out' / 'cosim' / 'tb_abrt.json').open() as json_file:
    ARGS = load(json_file)

XARGS = enc_args([ARGS["bin"]] + ARGS["sim"])

run(ARGS["bin"], len(XARGS) - 1, XARGS)

print("PY COSIM EXIT")
