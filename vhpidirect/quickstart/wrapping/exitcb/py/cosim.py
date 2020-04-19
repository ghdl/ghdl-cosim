from pyaux import dlopen, dlclose, enc_args, run
from pathlib import Path

print("PY COSIM ENTER")

run(str(Path(__file__).resolve().parent.parent / "tb-fail.so"), 0, None)

print("PY COSIM EXIT")
