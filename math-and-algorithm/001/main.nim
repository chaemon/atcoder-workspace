const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  echo N + 5
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

