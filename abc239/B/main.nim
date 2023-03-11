const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(X:int):
  echo X.floorDiv 10
  discard

when not DO_TEST:
  var X = nextInt()
  solve(X)
else:
  discard

