# When VHDL 1993 is used, the simulation is terminated with an `abort`, which prevents the user from running post-checks.
# These are some snippets to test it. See https://github.com/VUnit/vunit/pull/469#issuecomment-485723516.

import os
import signal

#https://bugs.python.org/issue12423

def handler(signum, frame):
    print('Signal handler called with signal', signum)

signal.signal(signal.SIGABRT, handler)
os.abort()
