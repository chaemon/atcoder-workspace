include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

import atcoder/extra/math/eratosthenes
import atcoder/extra/math/divisor
import atcoder/extra/math/combination

proc solve(N:int, M:int) =
  let L = 20
  var dp = Seq[M + 1, L : mint]
  es := initEratosthenes()
  for d in 1..M:
    let f = es.factor(d)
    dp[d][0] = 1
    for d2 in f.divisor:
      if d2 == d: continue
      for l in 0..<L-1:
        dp[d][l+1] += dp[d2][l]
  var ans = mint(0)
  for d in 1..M:
    for l in 0..<L:
      ans += mint.C(N - 1, l) * dp[d][l]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
#}}}

