when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, K:int, A:seq[int], B:seq[int], C:seq[int], E:seq[int]):
  var dp = Seq[N: int.inf]
  dp[0] = 0
  for i in K:
    let ei = E[i]
    dp[B[ei]].min=dp[A[ei]] + C[ei]
  echo if dp[N - 1] == int.inf: -1 else: dp[N - 1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  var E = newSeqWith(K, nextInt())
  solve(N, M, K, A.pred, B.pred, C, E.pred)
else:
  discard

