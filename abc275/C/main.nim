when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:seq[string]):
  discard

when not defined(DO_TEST):
  var S = newSeqWith(9, nextString())
  solve(S)
else:
  discard

