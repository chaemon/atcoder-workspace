const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, L:int):
  var dp = Seq[N + 1: mint(0)]
  dp[0] = 1
  for i in 1 .. N:
    dp[i] += dp[i - 1]
    if i - L >= 0:
      dp[i] += dp[i - L]
  echo dp[N]
  return

when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  solve(N, L)
