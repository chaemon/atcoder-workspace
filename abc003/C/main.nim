const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, K:int, R:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var R = newSeqWith(N, nextInt())
  solve(N, K, R)
else:
  discard

