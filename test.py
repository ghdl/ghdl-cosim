"""
Verify that all example run scripts work correctly
"""

from sys import executable, platform
from os import environ
from pathlib import Path
from subprocess import check_call
import unittest
import pytest


class TestExamples(unittest.TestCase):
    """
    Verify that example run scripts work correctly
    """

    def setUp(self):
        self.shell = ['bash'] if platform == 'win32' else []
        self.root = Path(__file__).parent
        self.vhpidirect = self.root / 'vhpidirect'
        self.vpi = self.root / 'vpi'

    def test_vhpidirect_quickstart_random(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'random' / 'run.sh')], shell=True)

    def test_vhpidirect_quickstart_math(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'math' / 'run.sh')], shell=True)

    def test_vhpidirect_quickstart_customc(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'customc' / 'run.sh')], shell=True)

    def test_vhpidirect_quickstart_wrapping_basic(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'wrapping' / 'basic' / 'run.sh')], shell=True)

    def test_vhpidirect_quickstart_wrapping_time(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'wrapping' / 'time' / 'run.sh')], shell=True)

    @unittest.skipUnless(
        platform != 'win32',
        "win: needs investigation, output of list-link seems to have wrong path format",
    )
    def test_vhpidirect_quickstart_linking_bind(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'linking' / 'bind' / 'run.sh')], shell=True)

    def test_vhpidirect_quickstart_package(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'package' / 'run.sh')], shell=True)

    def test_vhpidirect_quickstart_sharedvar(self):
        check_call(self.shell + [str(self.vhpidirect / 'quickstart' / 'sharedvar' / 'run.sh')], shell=True)

    def test_vhpidirect_shared_shlib(self):
        check_call(self.shell + [str(self.vhpidirect / 'shared' / 'shlib' / 'run.sh')], shell=True)

    @unittest.skipUnless(
        platform != 'win32',
        "win: dlfcn.h is not available on win",
    )
    def test_vhpidirect_shared_dlopen(self):
        check_call(self.shell + [str(self.vhpidirect / 'shared' / 'dlopen' / 'run.sh')], shell=True)

    @unittest.skipUnless(
        platform != 'win32',
        "win: dlfcn.h is not available on win",
    )
    def test_vhpidirect_shared_shghdl(self):
        check_call(self.shell + [str(self.vhpidirect / 'shared' / 'shghdl' / 'run.sh')], shell=True)

    def test_vhpidirect_arrays_intvector(self):
        check_call(self.shell + [str(self.vhpidirect / 'arrays' / 'intvector' / 'run.sh')], shell=True)

    def test_vhpidirect_arrays_logicvector(self):
        check_call(self.shell + [str(self.vhpidirect / 'arrays' / 'logicvector' / 'run.sh')], shell=True)

    def test_vhpidirect_arrays_matrices(self):
        check_call(self.shell + [str(self.vhpidirect / 'arrays' / 'matrices' / 'run.sh')], shell=True)

    def test_vhpidirect_arrays_matrices_vunit_axis_vcs(self):
        check_call([executable, str(self.vhpidirect / 'arrays' / 'matrices' / 'vunit_axis_vcs' / 'run.py')], shell=True)

    @unittest.skipUnless(
        platform != 'win32',
        "win: needs ImageMagick's 'convert'",
    )
    def test_vhpidirect_arrays_matrices_framebuffer(self):
        check_call(self.shell + [str(self.vhpidirect / 'arrays' / 'matrices' / 'framebuffer' / 'run.sh')], shell=True)

    def test_vpi_quickstart(self):
        check_call(self.shell + [str(self.vpi / 'quickstart' / 'run.sh')], shell=True)
