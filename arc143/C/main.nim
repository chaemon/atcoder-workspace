const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, Y:int, A:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, Y, A)
else:
  discard

