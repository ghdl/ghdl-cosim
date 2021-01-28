"""
Verify that vhpidirect/quickstart example run scripts work correctly
"""

from common import TestVHPIDIRECT, isWin


class TestQuickStart(TestVHPIDIRECT):
    """
    Verify that vhpidirect/quickstart example run scripts work correctly
    """

    def test_random(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'random' / 'run.sh')])


    def test_math(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'math' / 'run.sh')])


    def test_customc(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'customc' / 'run.sh')])


    def test_wrapping_basic(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'wrapping' / 'basic' / 'run.sh')])


    def test_wrapping_time(self):
        self._sh([
            str(self.vhpidirect / 'quickstart' / 'wrapping' / 'time' / 'run.sh'),
            '' if isWin else 'ada'
        ])


    def test_wrapping_exitcb(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'wrapping' / 'exitcb' / 'run.sh')])


    def test_linking_bind(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'linking' / 'bind' / 'run.sh')])


    def test_package(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'package' / 'run.sh')])


    def test_sharedvar(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'sharedvar' / 'run.sh')])


    def test_cli(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'cli' / 'run.sh')])

    def test_cli_fcnargs(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'cli' / 'fcnargs' / 'run.sh')])

    def test_cli_fcngen(self):
        self._sh([str(self.vhpidirect / 'quickstart' / 'cli' / 'fcngen' / 'run.sh')])
