const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:string):
  echo S[^1]
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

