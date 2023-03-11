const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, L:seq[int], R:seq[int], X:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  var X = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt()
    R[i] = nextInt()
    X[i] = nextInt()
  solve(N, Q, L, R, X)
else:
  discard

