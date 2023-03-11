const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, A:int):
  return

when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  solve(N, A)
else:
  discard

