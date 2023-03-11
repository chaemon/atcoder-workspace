const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(L:int, R:int, M:int):
  discard

when not DO_TEST:
  var L = nextInt()
  var R = nextInt()
  var M = nextInt()
  solve(L, R, M)
else:
  discard

