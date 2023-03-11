const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string):
  echo S[(S.len) div 2]
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

