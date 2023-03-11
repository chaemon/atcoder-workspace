const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, W:int):
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  solve(H, W)
else:
  discard

