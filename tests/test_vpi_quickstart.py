"""
Verify that vpi/quickstart example run scripts work correctly
"""

from common import TestVPI


class TestQuickStart(TestVPI):
    """
    Verify that vpi/quickstart example run scripts work correctly
    """

    def test_quickstart(self):
        self._sh([str(self.vpi / 'quickstart' / 'run.sh')])
