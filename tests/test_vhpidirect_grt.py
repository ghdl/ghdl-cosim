"""
Verify that vhpidirect/grt example run scripts work correctly
"""

from common import TestVHPIDIRECT


class TestGRT(TestVHPIDIRECT):
    """
    Verify that vhpidirect/grt example run scripts work correctly
    """

    def test_step(self):
        self._sh([str(self.vhpidirect / 'grt' / 'step' / 'run.sh')])
