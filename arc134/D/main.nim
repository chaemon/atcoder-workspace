const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, a:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(2*N, nextInt())
  solve(N, a)
else:
  discard

