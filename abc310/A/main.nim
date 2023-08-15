when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:int, Q:int, D:seq[int]):
  echo min(P, Q + D.min)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var D = newSeqWith(N, nextInt())
  solve(N, P, Q, D)
else:
  discard

