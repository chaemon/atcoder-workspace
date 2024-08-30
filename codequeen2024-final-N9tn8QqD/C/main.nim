when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/dp/cumulative_sum

solveProc solve(N:int, K:int, T:int, P:seq[int]):
  var cs = initCumulativeSum[int](N)
  for i in N:
    cs[i] = P[i]
  var dp = Seq[N + 1, K + 1: int.inf]
  dp[0][0] = 0
  for t in N:
    # 時刻tでは乗らない
    for k in 0 .. K:
      dp[t + 1][k].min=dp[t][k]
    # 時刻t ..< t + Tから乗る
    if t + T <= N:
      let s = cs[t ..< t + T]
      for k in 0 ..< K:
        dp[t + T][k + 1].min=dp[t][k] + s
  echo dp[N][K]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var T = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, K, T, P)
else:
  discard

