"""
Verify that vhpidirect/vffi example run scripts work correctly
"""

import pytest
from os import environ
from shutil import which
from common import TestVHPIDIRECT, isWin


class TestVFFI(TestVHPIDIRECT):
    """
    Verify that vhpidirect/vffi example run scripts work correctly
    """

    @pytest.mark.skipif(
        isWin and ('MINGW_PREFIX' not in environ),
        reason="needs OpenSSL",
    )
    def test_crypto(self):
        self._sh([str(self.vhpidirect / 'vffi_user' / 'crypto' / 'run.sh')])


    @pytest.mark.skipif(
        not which('Xyce'),
        reason="needs Xyce",
    )
    def test_xyce(self):
        self._py([str(self.vhpidirect / 'vffi_user' / 'xyce' / 'run_minimal.py'), '-v', '--clean', '--xunit-xml=%s' % str(self.report_file), '--output-path=%s' % str(self.output_path)])
        self._py([str(self.vhpidirect / 'vffi_user' / 'xyce' / 'run.py'), '-v', '--clean', '--xunit-xml=%s' % str(self.report_file), '--output-path=%s' % str(self.output_path)])
