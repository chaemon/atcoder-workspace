const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, A:seq[int], Q:int, S:seq[int], T:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, nextInt())
  var Q = nextInt()
  var S = newSeqWith(Q, 0)
  var T = newSeqWith(Q, 0)
  for i in 0..<Q:
    S[i] = nextInt()
    T[i] = nextInt()
  solve(N, M, A, Q, S, T)
else:
  discard

