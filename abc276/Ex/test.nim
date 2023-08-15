when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitset

solveProc solve():
  var u = Seq[int]

  discard

when not defined(DO_TEST):
  solve()
else:
  discard

