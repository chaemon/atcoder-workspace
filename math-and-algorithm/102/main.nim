const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, c:seq[string]):
  discard

when not DO_TEST:
  var N = nextInt()
  var c = newSeqWith(1, nextString())
  solve(N, c)
else:
  discard

