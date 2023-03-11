const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, X:seq[int], C:seq[int], Y:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(N, nextInt())
  var C = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    C[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, X, C, Y)
else:
  discard

