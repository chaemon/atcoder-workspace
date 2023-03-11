const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, s:string):
  discard

when not DO_TEST:
  var N = nextInt()
  var s = nextString()
  solve(N, s)
else:
  discard

