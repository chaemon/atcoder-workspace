when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int], P:int, X:seq[int], Q:int, Y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var P = nextInt()
  var X = newSeqWith(P, nextInt())
  var Q = nextInt()
  var Y = newSeqWith(Q, nextInt())
  solve(N, A, P, X, Q, Y)
else:
  discard

