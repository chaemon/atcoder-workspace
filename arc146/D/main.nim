const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, K:int, P:seq[int], X:seq[int], Q:seq[int], Y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var P = newSeqWith(K, 0)
  var X = newSeqWith(K, 0)
  var Q = newSeqWith(K, 0)
  var Y = newSeqWith(K, 0)
  for i in 0..<K:
    P[i] = nextInt()
    X[i] = nextInt()
    Q[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, K, P, X, Q, Y)
else:
  discard

