const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, C:seq[int], P:seq[int], Q:int, L:seq[int], R:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var C = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    C[i] = nextInt()
    P[i] = nextInt()
  var Q = nextInt()
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, C, P, Q, L, R)
else:
  discard

