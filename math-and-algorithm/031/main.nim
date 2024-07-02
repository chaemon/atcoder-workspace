const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var 
    dp = Seq[N: -int.inf]
  for i in N:
    dp[i].max = A[i]
    if i >= 2:
      dp[i].max= dp[i - 2] + A[i]
    if i >= 3:
      dp[i].max= dp[i - 3] + A[i]
  echo max(dp[N - 1], dp[N - 2])

  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

