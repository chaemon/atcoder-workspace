const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, A:seq[int], X:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var X = newSeqWith(Q, nextInt())
  solve(N, Q, A, X)
else:
  discard

