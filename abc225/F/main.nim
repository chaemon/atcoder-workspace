const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(N:int, K:int, S:seq[string]):
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, K, S)
else:
  discard

