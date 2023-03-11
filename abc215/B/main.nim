const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int):
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

