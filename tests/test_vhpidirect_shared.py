"""
Verify that vhpidirect/shared example run scripts work correctly
"""

import pytest
from common import TestVHPIDIRECT, isWin


class TestShared(TestVHPIDIRECT):
    """
    Verify that vhpidirect/shared example run scripts work correctly
    """

    def test_shlib(self):
        self._sh([str(self.vhpidirect / 'shared' / 'shlib' / 'run.sh')])


    def test_dlopen(self):
        self._sh([str(self.vhpidirect / 'shared' / 'dlopen' / 'run.sh')])


    @pytest.mark.xfail(
        not isWin,
        reason="abortion is produced on some Linux environments"
    )
    def test_shghdl(self):
        self._sh([str(self.vhpidirect / 'shared' / 'shghdl' / 'run.sh')])


    @pytest.mark.xfail(
        not isWin,
        reason="abortion is produced on some Linux environments"
    )
    def test_py(self):
        self._sh([str(self.vhpidirect / 'shared' / 'py' / 'run.sh')])

    @pytest.mark.xfail(
        not isWin,
        reason="abortion is produced on some Linux environments"
    )
    def test_py_vunit(self):
        self._sh([str(self.vhpidirect / 'shared' / 'py' / 'vunit' / 'run.sh')])


    def test_pycb(self):
        self._sh([str(self.vhpidirect / 'shared' / 'pycb' / 'run.sh')])
