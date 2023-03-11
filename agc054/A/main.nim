const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:string):
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

