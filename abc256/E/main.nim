const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:seq[int], C:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  solve(N, X, C)
else:
  discard

