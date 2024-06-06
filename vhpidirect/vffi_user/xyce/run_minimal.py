from pathlib import Path
from subprocess import check_call
from vunit import VUnit


SRC = Path(__file__).parent.resolve() / "runACircuit"

VU = VUnit.from_argv(vhdl_standard="2008")
VU.add_vhdl_builtins()

VU.add_library("lib").add_source_files(SRC / "*.vhd")

VU.set_sim_option("ghdl.elab_flags", [
    "-Wl,-I%s" % SRC.parent.parent.parent,
    "-Wl," + str(SRC / "main.c"),
    "-Wl,-lxycecinterface"
])

VU.main()
