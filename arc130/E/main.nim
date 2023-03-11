const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, K:int, i:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var i = newSeqWith(K, nextInt())
  solve(N, K, i)
else:
  discard

