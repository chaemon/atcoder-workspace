const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string):
  for d in '0'..'9':
    if d notin S:
      echo d
  discard

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

