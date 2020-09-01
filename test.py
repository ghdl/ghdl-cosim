"""
Verify that all example run scripts work correctly
"""

import sys
from sys import executable, platform
from os import environ
from pathlib import Path
from subprocess import check_call, STDOUT
from shutil import which
import unittest
import pytest


isWin = platform == 'win32'


class TestExamples(unittest.TestCase):
    """
    Verify that example run scripts work correctly
    """

    def setUp(self):
        self.shell = [which('bash')] if platform == 'win32' else []
        self.root = Path(__file__).parent
        self.vhpidirect = self.root / 'vhpidirect'
        self.vpi = self.root / 'vpi'

        self.output_path = self.root / 'examples_run_out'
        self.report_file = self.output_path / 'xunit.xml'

        print('\n::group::Log')
        sys.stdout.flush()

    def tearDown(self):
        print('\n::endgroup::')
        sys.stdout.flush()


    def _sh(self, args):
        check_call(self.shell + args, stderr=STDOUT)

    def _py(self, args):
        check_call([executable] + args, stderr=STDOUT)


    def test_vhpidirect_quickstart_random(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'random' / 'run.sh')])


    def test_vhpidirect_quickstart_math(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'math' / 'run.sh')])


    def test_vhpidirect_quickstart_customc(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'customc' / 'run.sh')])


    def test_vhpidirect_quickstart_wrapping_basic(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'wrapping' / 'basic' / 'run.sh')])


    def test_vhpidirect_quickstart_wrapping_time(self):
        self._sh([
            str(self.vhpidirect / 'quickstart' / 'wrapping' / 'time' / 'run.sh'),
            'ada' if platform != 'win32' else ''
        ])


    @unittest.skipIf(
        isWin,
        'win: needs investigation, output of list-link seems to have wrong path format',
    )
    def test_vhpidirect_quickstart_linking_bind(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'linking' / 'bind' / 'run.sh')])


    def test_vhpidirect_quickstart_package(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'package' / 'run.sh')])


    def test_vhpidirect_quickstart_sharedvar(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'sharedvar' / 'run.sh')])


    def test_vhpidirect_quickstart_cli(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'cli' / 'run.sh')])

    def test_vhpidirect_quickstart_cli_fcnargs(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'cli' / 'fcnargs' / 'run.sh')])

    def test_vhpidirect_quickstart_cli_fcngen(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'cli' / 'fcngen' / 'run.sh')])


    def test_vhpidirect_shared_shlib(self):
        self._sh([str(self.vhpidirect / 'shared' / 'shlib' / 'run.sh')])


    @unittest.skipIf(
        isWin,
        'win: dlfcn.h is not available on win',
    )
    def test_vhpidirect_shared_dlopen(self):
        self._sh([str(self.vhpidirect / 'shared' / 'dlopen' / 'run.sh')])


    @unittest.skipIf(
        isWin,
        'win: dlfcn.h is not available on win',
    )
    def test_vhpidirect_shared_shghdl(self):
        self._sh([str(self.vhpidirect / 'shared' / 'shghdl' / 'run.sh')])


    def test_vhpidirect_shared_pycb(self):
        self._sh([str(self.vhpidirect / 'shared' / 'pycb' / 'run.sh')])


    def test_vhpidirect_arrays_intvector(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'intvector' / 'run.sh')])


    def test_vhpidirect_arrays_logicvector(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'logicvector' / 'run.sh')])


    def test_vhpidirect_arrays_matrices(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'matrices' / 'run.sh')])


    def test_vhpidirect_arrays_matrices_vunit_axis_vcs(self):
        self._py([str(self.vhpidirect / 'arrays' / 'matrices' / 'vunit_axis_vcs' / 'run.py'), '-v'])


    @unittest.skipIf(
        isWin,
        "win: needs ImageMagick's 'convert'",
    )
    def test_vhpidirect_arrays_matrices_framebuffer(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'matrices' / 'framebuffer' / 'run.sh')])


    def test_vhpidirect_vffi_demo(self):
        self._sh([str(self.vhpidirect / 'vffi_user' / 'demo' / 'run.sh')])

    @unittest.skipUnless(
        which('Xyce'),
        "needs Xyce",
    )
    def test_vhpidirect_vffi_xyce(self):
        self._py([str(self.vhpidirect / 'vffi_user' / 'xyce' / 'run_minimal.py'), '-v', '--clean', '--xunit-xml=%s' % str(self.report_file), '--output-path=%s' % str(self.output_path)])
        self._py([str(self.vhpidirect / 'vffi_user' / 'xyce' / 'run.py'), '-v', '--clean', '--xunit-xml=%s' % str(self.report_file), '--output-path=%s' % str(self.output_path)])


    def test_vpi_quickstart(self):
        self._sh([str(self.vpi / 'quickstart' / 'run.sh')])
