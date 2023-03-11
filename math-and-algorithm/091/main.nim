const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int):
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  solve(N, X)
else:
  discard

