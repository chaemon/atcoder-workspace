const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(R:int, C:int, A:seq[seq[int]]):
  echo A[R][C]
  discard

when not DO_TEST:
  var R = nextInt() - 1
  var C = nextInt() - 1
  var A = newSeqWith(2, newSeqWith(2, nextInt()))
  solve(R, C, A)
else:
  discard

