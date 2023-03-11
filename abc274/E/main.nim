when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, X:seq[int], Y:seq[int], P:seq[int], Q:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  var P = newSeqWith(M, 0)
  var Q = newSeqWith(M, 0)
  for i in 0..<M:
    P[i] = nextInt()
    Q[i] = nextInt()
  solve(N, M, X, Y, P, Q)
else:
  discard

