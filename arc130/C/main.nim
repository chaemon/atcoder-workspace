const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(a:string, b:string):
  return

when not DO_TEST:
  var a = nextString()
  var b = nextString()
  solve(a, b)
else:
  discard

