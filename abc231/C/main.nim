const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, A:seq[int], x:seq[int]):
  var A = sorted A
  for i in Q:
    echo N - A.lowerBound(x[i])
  return

when not DO_TEST:
  let N, Q = nextInt()
  var A = Seq[N:nextInt()]
  var x = Seq[Q:nextInt()]
  solve(N, Q, A, x)
else:
  discard

