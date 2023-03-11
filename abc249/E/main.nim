const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum
import atcoder/modint
type mint = modint

solveProc solve(N:int, P:int):
  mint.setMod(P)
  var
    dp = Seq[N: initDualCumulativeSum[mint](N + 1)] # T, S
    ans = mint(0)
  dp[0].add(0..0, 1)
  for t in 0..<N:
    let p = if t == 0: 26 else: 25
    for s in 0..N:
      for i, d in [1, 10, 100, 1000]:
        var
          j = t + i + 2
          l = s + d
          r = min(N + 1, s + d * 10)
        if j >= N: continue
        if l >= r: continue
        dp[j].add(l ..< r, dp[t][s] * p)
    ans += dp[t][N]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var P = nextInt()
  solve(N, P)
else:
  discard

