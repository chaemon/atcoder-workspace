const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int, h: seq[int]):
  var dp = Seq[N: int.inf]
  dp[0] = 0
  for i in N:
    if i - 1 >= 0:
      dp[i].min = dp[i - 1] + abs(h[i] - h[i - 1])
    if i - 2 >= 0:
      dp[i].min = dp[i - 2] + abs(h[i] - h[i - 2])
  echo dp[N - 1]
  discard

when not DO_TEST:
  var N = nextInt()
  var h = newSeqWith(N, nextInt())
  solve(N, h)
else:
  discard

