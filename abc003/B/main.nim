const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(S:string, T:string):
  return

when not DO_TEST:
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

