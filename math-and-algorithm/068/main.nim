const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, K:int, V:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var V = newSeqWith(K, nextInt())
  solve(N, K, V)
else:
  discard

