const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string):
  discard

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

