const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, P:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  discard

