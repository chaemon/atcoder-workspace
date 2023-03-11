when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum_2d

import atcoder/modint
type mint = modint

solveProc solve(N:int, K:int, P:int):
  mint.setMod(P)
  var dp = Seq[N, N, K + 1: mint(0)]
  var cs = Seq[K + 1: initDualCumulativeSum2D[mint](N, N)]
  dp[0][0][0] = 1
  for m in 2 .. N:
    # 追加分も含めて全部でk個
    for k in 0 .. K:
      cs[k].init(m, m)
    for i in m - 1:
      for j in m - 1:
        for k in 0 .. K:
          # 今(i, j), 次(i2, j2)
          # i2 >= i, j2 >= jのとき、類似度増える
          # i < i2, j < j2のとき、類似度増える
          if k < K:
            cs[k + 1].add(0 .. i, 0 .. j, dp[i][j][k])
            cs[k + 1].add(i + 1 ..< m, j + 1 ..< m, dp[i][j][k])
          # その他は増えない
          cs[k].add(0 .. i, j + 1 ..< m, dp[i][j][k])
          cs[k].add(i + 1 ..< m, 0 .. j, dp[i][j][k])
    # dpへ反映
    dp.fill(mint(0))
    for k in 0 .. K:
      cs[k].build()
    for i in m:
      for j in m:
        for k in 0 .. K:
          dp[i][j][k] = cs[k][i, j]
  ans := mint(0)
  for i in N:
    for j in N:
      ans += dp[i][j][K]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var P = nextInt()
  solve(N, K, P)
else:
  discard

