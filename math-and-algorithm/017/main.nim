const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var l = lcm(A[0], A[1])
  for i in 2 ..< N:
    l = lcm(l, A[i])
  echo l
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

