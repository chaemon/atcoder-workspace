when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, C:seq[string], D:seq[string], P:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var C = newSeqWith(N, nextString())
  var D = newSeqWith(M, nextString())
  var P = newSeqWith(M+1, nextInt())
  solve(N, M, C, D, P)
else:
  discard

