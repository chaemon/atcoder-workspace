when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var dp = Seq[N: int.inf]
  dp[0] = 0
  for i in 1 ..< N:
    dp[i].min=dp[i - 1] + A[i - 1]
    if i >= 2:
      dp[i].min=dp[i - 2] + B[i - 2]
  echo dp[N - 1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-2+1, nextInt())
  var B = newSeqWith(N-3+1, nextInt())
  solve(N, A, B)
else:
  discard

