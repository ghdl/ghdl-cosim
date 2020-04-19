from vunit import VUnit
from os import makedirs, getenv
from pathlib import Path
from shutil import copyfile
import re


def post_func(results):
    """
    Copy args.json to vunit/cosim/*.json
    """
    report = results.get_report()
    cosim_args_dir = Path(report.output_path) / "cosim"
    try:
        makedirs(str(cosim_args_dir))
    except FileExistsError:
        pass
    for key, item in report.tests.items():
        copyfile(
            str(Path(item.path) / "ghdl" / "args.json"),
            str(
                cosim_args_dir / ("%s.json" % re.search(r"lib\.(.+)\.all", key)[1])
            ),
        )


ROOT = Path(__file__).resolve().parent

vu = VUnit.from_argv(vhdl_standard=getenv('VUNIT_VHDL_STANDARD', '2008'))

lib = vu.add_library('lib').add_source_files(str(ROOT / 'vunit_tb.vhd'))

vu.set_sim_option('ghdl.elab_flags', [
    '-shared',
    '-Wl,-fPIC',
    '-Wl,' + str(ROOT.parent / 'caux.c'),
    '-Wl,' + str(ROOT.parent / 'main_sigabrt.c')
])

vu.set_sim_option("ghdl.elab_e", True)
vu._args.elaborate = True

vu.main(post_run=post_func)
