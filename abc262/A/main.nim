const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(Y:int):
  var Y = Y
  while true:
    if Y mod 4 == 2:
      echo Y;return
    Y.inc
  discard

when not DO_TEST:
  var Y = nextInt()
  solve(Y)
else:
  discard

