const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, A:seq[int]):
  var dp = Seq[10: mint(0)]
  dp[(A[0] + A[1]) mod 10] += 1
  dp[(A[0] * A[1]) mod 10] += 1
  for i in 2..<N:
    var dp2 = Seq[10:mint(0)]
    for u in 10:
      dp2[(u + A[i]) mod 10] += dp[u]
      dp2[(u * A[i]) mod 10] += dp[u]
    swap dp, dp2
  for u in 10:
    echo dp[u]
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

