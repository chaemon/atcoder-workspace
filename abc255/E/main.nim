const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, S:seq[int], X:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N-1, nextInt())
  var X = newSeqWith(M, nextInt())
  solve(N, M, S, X)
else:
  discard

