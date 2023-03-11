const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, X:int, T:int, D:int):
  var t = T - D * X
  for i in 0 .. N:
    if i == M:
      echo t;return
    if i < X:
      t += D
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var X = nextInt()
  var T = nextInt()
  var D = nextInt()
  solve(N, M, X, T, D)
else:
  discard

