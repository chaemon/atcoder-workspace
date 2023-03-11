const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(L:int, R:int):
  discard

when not DO_TEST:
  var L = nextInt()
  var R = nextInt()
  solve(L, R)
else:
  discard

