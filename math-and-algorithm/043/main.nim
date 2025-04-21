const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/dsu

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  Pred A, B
  var dsu = initDSU(N)
  for i in M:
    dsu.merge(A[i], B[i])
  if dsu.size(0) == N:
    echo "The graph is connected."
  else:
    echo "The graph is not connected."

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

