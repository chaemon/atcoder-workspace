const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, L:int):
  return

when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  solve(N, L)
else:
  discard

