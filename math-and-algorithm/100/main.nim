const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(Q:int, X:seq[float], Y:seq[float], Z:seq[float], T:seq[int]):
  discard

when not DO_TEST:
  var Q = nextInt()
  var X = newSeqWith(Q, 0.0)
  var Y = newSeqWith(Q, 0.0)
  var Z = newSeqWith(Q, 0.0)
  var T = newSeqWith(Q, 0)
  for i in 0..<Q:
    X[i] = nextFloat()
    Y[i] = nextFloat()
    Z[i] = nextFloat()
    T[i] = nextInt()
  solve(Q, X, Y, Z, T)
else:
  discard

