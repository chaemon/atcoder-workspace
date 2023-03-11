const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, L:int, R:int, A:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  var R = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, L, R, A)
else:
  discard

