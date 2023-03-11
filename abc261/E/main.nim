const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, C:int, T:seq[int], A:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var C = nextInt()
  var T = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    A[i] = nextInt()
  solve(N, C, T, A)
else:
  discard

