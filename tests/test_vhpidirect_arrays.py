"""
Verify that vhpidirect/arrays example run scripts work correctly
"""

import pytest
from common import TestVHPIDIRECT, isWin


class TestArrays(TestVHPIDIRECT):
    """
    Verify that vhpidirect/arrays example run scripts work correctly
    """

    def test_intvector(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'intvector' / 'run.sh')])


    def test_logicvector(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'logicvector' / 'run.sh')])


    def test_matrices(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'matrices' / 'run.sh')])


    def test_matrices_vunit_axis_vcs(self):
        self._py([str(self.vhpidirect / 'arrays' / 'matrices' / 'vunit_axis_vcs' / 'run.py'), '-v'])


    @pytest.mark.skipif(
        isWin,
        reason="win: needs ImageMagick's 'convert'",
    )
    def test_matrices_framebuffer(self):
        self._sh([str(self.vhpidirect / 'arrays' / 'matrices' / 'framebuffer' / 'run.sh')])
