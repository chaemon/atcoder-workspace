when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  Pred A, B
  var dp = Seq[N: -int.inf]
  dp[0] = 0
  for i in N - 1:
    if dp[i] == -int.inf: continue
    dp[A[i]].max=dp[i] + 100
    dp[B[i]].max=dp[i] + 150
  echo dp[N - 1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, nextInt())
  var B = newSeqWith(N-1, nextInt())
  solve(N, A, B)
else:
  discard

