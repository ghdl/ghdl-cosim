from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv(vhdl_standard="2008")
VU.add_verification_components()

ROOT = Path(__file__).resolve().parent

VU.add_library("lib").add_source_files([ROOT.parent / "pkg.vhd", ROOT / "src" / "*.vhd", ROOT / "*.vhd"])

VU.set_compile_option("ghdl.flags", ["-frelaxed"])
# Add the C wrapper to the elaboration of GHDL
VU.set_sim_option("ghdl.elab_flags", ["-frelaxed", "-Wl," + str(ROOT.parent / "main.c")])

VU.main()
