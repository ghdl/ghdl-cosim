from pathlib import Path
from subprocess import check_call
from vunit import VUnit


RUN = Path(__file__).parent.resolve()

VU = VUnit.from_argv(vhdl_standard="2008")
VU.add_vhdl_builtins()

for PRJ in ["runACircuitInSteps", "runWithDACs"]:
    LIB = VU.add_library(PRJ)
    LIB.add_source_files([
        RUN / "pkg" / "*.vhd",
        RUN / PRJ / "*.vhd"
    ])
    LIB.set_sim_option("ghdl.elab_flags", [
        "-Wl,-I%s" % RUN.parent.parent,
        "-Wl,-I%s" % RUN,
        "-Wl," + str(RUN / "vffi_xyce.c"),
        "-Wl,-lxycecinterface"
    ])

VU.main()
