const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, K:int, U:seq[int], V:seq[int]):
  var dp = Seq[N:mint(0)]
  dp[0] = 1
  for _ in K:
    let S = dp.sum
    var dp2 = Seq[N:S]
    for u in N: dp2[u] -= dp[u]
    for i in M:
      dp2[U[i]] -= dp[V[i]]
      dp2[V[i]] -= dp[U[i]]
    swap dp, dp2
  echo dp[0]
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  solve(N, M, K, U, V)
