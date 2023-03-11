const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(S:string):
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

