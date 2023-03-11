const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, A:seq[int]):
  var X = X
  var vis = Seq[N: false]
  while true:
    if vis[X]: break
    vis[X] = true
    X = A[X]
  echo vis.count(true)
  return

when not DO_TEST:
  var N = nextInt()
  var X = nextInt() - 1
  var A = newSeqWith(N, nextInt() - 1)
  solve(N, X, A)
else:
  discard

