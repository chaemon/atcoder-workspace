const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(n:int, m:int, s:string, t:string):
  discard

when not DO_TEST:
  var n = nextInt()
  var m = nextInt()
  var s = nextString()
  var t = nextString()
  solve(n, m, s, t)
else:
  discard

