when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, S:seq[string], T:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  var T = newSeqWith(M, nextString())
  solve(N, M, S, T)
else:
  discard

