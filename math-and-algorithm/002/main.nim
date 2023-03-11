const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:seq[int]):
  echo A.sum
  discard

when not DO_TEST:
  var A = newSeqWith(3, nextInt())
  solve(A)
else:
  discard

