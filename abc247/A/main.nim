const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string):
  var S = '0' & S[0..2]
  echo S
  discard

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

