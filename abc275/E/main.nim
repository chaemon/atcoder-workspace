when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, K:int):
  var dp = Seq[N + 1: mint(0)]
  let p = mint(1) / mint(M)
  dp[0] = 1
  for i in K:
    var dp2 = Seq[N + 1: mint(0)]
    for x in 0 .. N:
      for d in 1 .. M:
        var x2 = x + d
        if x2 > N:
          x2 = N - (x2 - N)
        dp2[x2] += dp[x] * p
    dp2[N] = 0
    swap dp, dp2
  echo 1 - dp.sum
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  solve(N, M, K)
else:
  discard

