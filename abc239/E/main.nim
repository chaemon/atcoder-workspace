const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, X:seq[int], A:seq[int], B:seq[int], V:seq[int], K:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var X = newSeqWith(N, nextInt())
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
  var V = newSeqWith(Q, 0)
  var K = newSeqWith(Q, 0)
  for i in 0..<Q:
    V[i] = nextInt()
    K[i] = nextInt()
  solve(N, Q, X, A, B, V, K)
else:
  discard

