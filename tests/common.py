"""
Verify that all example run scripts work correctly
"""

import sys
from sys import executable, platform
from pathlib import Path
from subprocess import check_call, STDOUT
from shutil import which
from unittest import TestCase


isWin = platform == 'win32'


class TestExamples(TestCase):
    """
    Verify that example run scripts work correctly
    """

    def __init__(self, name):
        super().__init__(name)
        self.shell = [which('bash')] if platform == 'win32' else []
        self.root = Path(__file__).parent.parent


    def setUp(self):
        print('\n::group::Log')
        sys.stdout.flush()

    def tearDown(self):
        print('\n::endgroup::')
        sys.stdout.flush()


    def _sh(self, args):
        check_call(self.shell + args, stderr=STDOUT)

    def _py(self, args):
        check_call([executable] + args, stderr=STDOUT)


class TestVHPIDIRECT(TestExamples):

    def __init__(self, name):
        super().__init__(name)
        self.vhpidirect = self.root / 'vhpidirect'
        self.output_path = self.root / 'examples_run_out'
        self.report_file = self.output_path / 'xunit.xml'


class TestVPI(TestExamples):

    def __init__(self, name):
        super().__init__(name)
        self.vpi = self.root / 'vpi'
