const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header



solveProc solve(N:int, A:seq[int]):
  var v = collect(newSeq):
    for i in N: (A[i], i)
  v.sort
  echo v[^2][1] + 1
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)

