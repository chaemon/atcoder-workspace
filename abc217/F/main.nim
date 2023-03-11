const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
#  var g = Seq[N * 2, N * 2: false]
  var g = Array[401, 401: false]
  for i in M:
    g[A[i]][B[i]] = true
    g[B[i]][A[i]] = true
  var dp = Array[401, 401: mint(0)]
  for i in 0..N*2:
    dp[i][0] = mint(1)
  for d in 1 .. N:
    for i in 0 ..< N * 2:
      let j = i + d * 2
      if j > N * 2: break
      # i ..< j
      # set dp2[i][j]
      for dd in 1 .. d:
        # i & (i + dd * 2)
        let i2 = i + dd * 2 - 1
        if i2 >= N * 2 or not g[i][i2]: continue
        dp[i][d] += dp[i + 1][dd - 1] * dp[i2 + 1][d - dd] * mint.C(d, dd)
  echo dp[0][N]
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, M, A, B)
else:
  discard

