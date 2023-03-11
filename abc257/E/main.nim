const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, C:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var C = newSeqWith(9, nextInt())
  solve(N, C)
else:
  discard

