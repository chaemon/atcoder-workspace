when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, K:int, S:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, K, S)
else:
  discard

