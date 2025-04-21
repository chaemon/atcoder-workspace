when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, Q:int, P:int, A:seq[int], B:seq[int], D:seq[int], G:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var P = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  var D = newSeqWith(Q, 0)
  var G = newSeqWith(Q, 0)
  for i in 0..<Q:
    D[i] = nextInt()
    G[i] = nextInt()
  solve(N, M, Q, P, A, B, D, G)
else:
  discard

