const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(X:int):
  echo X^3
  return

when not DO_TEST:
  var X = nextInt()
  solve(X)
else:
  discard

