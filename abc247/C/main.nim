const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  var a = @[1]
  for i in 2..N:
    a = a & i & a
  echo a.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

