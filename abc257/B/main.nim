const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, K:int, Q:int, A:seq[int], L:seq[int]):
  var A = A
  for q in Q:
    if A[L[q]] < N and (L[q] == K - 1 or A[L[q]] + 1 < A[L[q] + 1]):
      A[L[q]].inc
  echo A.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var Q = nextInt()
  var A = newSeqWith(K, nextInt())
  var L = newSeqWith(Q, nextInt() - 1)
  solve(N, K, Q, A, L)
else:
  discard

