const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int):
  echo sqrt(H.float * (12800000.0 + H.float))
  discard

when not DO_TEST:
  var H = nextInt()
  solve(H)
else:
  discard

