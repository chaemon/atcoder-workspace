const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, x:seq[int], y:seq[int], P:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
    P[i] = nextInt()
  solve(N, x, y, P)
else:
  discard

