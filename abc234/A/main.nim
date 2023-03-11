const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(t:int):
  proc f(t:int):int = t^2 + 2 * t + 3
  echo f(f(f(t) + t) + f(f(t)))
  discard

when not DO_TEST:
  var t = nextInt()
  solve(t)
else:
  discard

