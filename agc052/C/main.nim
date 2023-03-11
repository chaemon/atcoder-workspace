const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import atcoder/extra/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, P:int):
  var dp = Seq[N + 1: mint]
  var p = mint(1)
  for i in 1..<N:
    p *= P - 1
    dp[i] += p * mint.rfact(i)
  for s in 0..<N:
    for i in 1..<N:
      if s + i > N: break
      dp[s + i] += mint(P - 1 - i)^i * mint.rfact(i)
  echo dp[N] * mint.fact(N)
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var P = nextInt()
  solve(N, P, true)
#}}}

