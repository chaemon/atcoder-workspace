const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, T:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var T = newSeqWith(N, nextInt())
  solve(N, T)
else:
  discard

