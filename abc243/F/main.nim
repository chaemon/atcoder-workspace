const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, K:int, W:seq[int]):
  var dp = Seq[K + 1, M + 1:mint(0)] # 引いた個数、種類
  dp[0][0] = mint(1)
  for i in N:
    var dp2 = dp
    for k in 0..K:
      for m in 0..<M:
        var p = mint(1)
        for d in 1..K:
          p *= W[i]
          if k + d <= K:
            dp2[k + d][m + 1] += dp[k][m] * mint.C(k + d, d) * p
    swap dp, dp2
  echo dp[K][M] / mint(W.sum)^K
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var W = newSeqWith(N, nextInt())
  solve(N, M, K, W)
else:
  discard

