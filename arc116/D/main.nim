include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/math/combination

const DEBUG = true

proc solve(N:int, M:int) =
  const B = 13
  var dp = Seq[M + 1: mint(0)]
  dp[0] = 1
  for i in 0..<B:
    var dp2 = Seq[M + 1: mint(0)]
    let t = 2^i
    for j in 0..M:
      let T = min(M, N)
      for m in countup(0, T, 2):
        let s = j + t * m
        if s > M: break
        dp2[s] += dp[j] * mint.C(N, m)
    swap(dp, dp2)
  echo dp[M]
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
#}}}

