const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, K:int, A:seq[int]):
  var dp = Seq[N + 1:mint]
  dp[0] = 1
  for i in N:
    var dp2 = Seq[N + 1: mint]
    for k in 0..N:
      # use
      if K - k >= 0 and k + 1 <= N:
        dp2[k + 1] += (K - k) * dp[k]
      # not use
      dp2[k] += A[i] * dp[k]
    swap dp, dp2
  var s = mint(0)
  for k in 0..N:
    if K - k < 0: continue
    s += mint(N)^(K - k) * dp[k]
  echo s / mint(N)^K
  return

when not DO_TEST:
  let N, K = nextInt()
  let A = Seq[N:nextInt()]
  solve(N, K, A)
else:
  discard
