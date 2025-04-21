when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, P:seq[int], Q:seq[int], K:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = newSeqWith(M, 0)
  var Q = newSeqWith(M, 0)
  var K = newSeqWith(M, 0)
  for i in 0..<M:
    P[i] = nextInt()
    Q[i] = nextInt()
    K[i] = nextInt()
  solve(N, M, P, Q, K)
else:
  discard

