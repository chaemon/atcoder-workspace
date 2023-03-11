const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var a = Seq[2 * 10^5 + 1: 0]
  for i in N: a[A[i]].inc
  var dp = Seq[4:0]
  dp[0] = 1
  for i in a.len:
    dp2 := dp
    for j in 3:
      dp2[j + 1] += dp[j] * a[i]
    swap dp, dp2
  echo dp[3]
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

