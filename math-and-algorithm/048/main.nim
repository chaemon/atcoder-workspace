const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(K:int):
  discard

when not DO_TEST:
  var K = nextInt()
  solve(K)
else:
  discard

