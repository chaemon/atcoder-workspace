const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  proc f(N:int):int =
    if N == 0: return 1
    else: return f(N - 1) * N
  echo f(N)
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

