const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, C:seq[int], X:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var C = newSeqWith(N, nextInt())
  var X = newSeqWith(N, nextInt())
  solve(N, C, X)
else:
  discard

