const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, K:int, P:seq[int], Q:seq[int]):
  var (P, Q) = (P, Q)
  for i in N:
    P[i] = N - 1 - P[i]
    Q[i] = N - 1 - Q[i]
  a := Seq[tuple[P, Q:int]]
  for i in N:
    a.add (P[i], Q[i])
  a.sort()
  dp := Seq[K + 1, N + 1: mint(0)] # 人数, 出てきたQの最小値(これより小さいのは必ず選ぶ)
  dp[0][N] = 1
  for i,(P, Q) in a:
    dp2 := Seq[K + 1, N + 1: mint(0)]
    # (P, Q)を採用しない
    for k in 0 .. K:
      for n in Q .. N:
        dp2[k][n] += dp[k][n]
    # (P, Q)を採用する
    for k in 0 ..< K:
      for n in 0 .. N:
        dp2[k + 1][min(n, Q)] += dp[k][n]
    swap dp, dp2
  ans := mint(0)
  for n in 0 .. N:
    ans += dp[K][n]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  var Q = newSeqWith(N, nextInt() - 1)
  solve(N, K, P, Q)
else:
  discard

