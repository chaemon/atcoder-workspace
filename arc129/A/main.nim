const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, L:int, R:int):
  discard

when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  var R = nextInt()
  solve(N, L, R)
else:
  discard

