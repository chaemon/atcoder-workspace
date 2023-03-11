const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  S := 0
  for i in 1..N: S += 4 * i
  for i in A.len: S -= A[i]
  echo S
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(4*N-1, nextInt())
  solve(N, A)
else:
  discard

