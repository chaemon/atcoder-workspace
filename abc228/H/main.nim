const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, A:seq[int], C:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    C[i] = nextInt()
  solve(N, X, A, C)
else:
  discard

