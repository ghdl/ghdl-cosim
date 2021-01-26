from sys import platform
from pathlib import Path
from json import load
from pyaux import enc_args, run


with (Path(__file__).parent / 'vunit_out' / 'cosim' / 'tb_vunit.json').open() as json_file:
    ARGS = load(json_file)

_bin = ARGS["bin"] if platform != 'win32' else ARGS["bin"]+'.exe'

run(_bin, len(ARGS), enc_args([_bin] + ARGS["sim"]))
