when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int):
  let MMAX = (N * (N - 1)) div 2
  var pw = Seq[M + 1, MMAX + 1: mint(0)] # pw[i][j] = i^j
  for i in 1 .. M:
    pw[i][0] = 1
    for j in 1 .. MMAX:
      pw[i][j] = pw[i][j - 1] * i
  var
    dpn, dps = Seq[N + 1, M + 1: mint(0)] # dp[n][m]: n頂点で1〜mの重みをつけた場合のMSTの重みの和
  # dp[1][M]は常に0
  for a in 0 .. M:
    dpn[1][a] = 1
    dps[1][a] = 0
  # dp[n][0]は(n - 1)
  for a in 1 .. M:
    for n in 2 .. N:
      var n0, s0 = mint(0)
      for k in 0 .. n - 2:
        # 最小インデックス含めたk + 1個がa未満で移動可で残りの頂点はn-k-1
        # それぞれS0, S1とする
        var
          p = mint(0)
          D = (k + 1) * (n - k - 1)
          n2 = pw[M - a + 1][D] - pw[M - a][D] # a .. Mを割り当てる。ただし、少なくとも1本はaを割り当てる
        debug n, a, k + 1, n - k - 1
        n0 += mint.C(n - 1, k) * dpn[k + 1][a - 1] * dpn[n - k - 1][a] * n2
        p += dps[k + 1][a - 1] * dpn[n - k - 1][a] * n2
        p += dpn[k + 1][a - 1] * dps[n - k - 1][a] * n2
        p += dps[k + 1][a - 1] * dpn[n - k - 1][a] * a
        s0 += mint.C(n - 1, k) * p
      dpn[n][a] = dpn[n][a - 1] + n0
      dps[n][a] = dps[n][a - 1] + s0
      debug n,a,dpn[n][a], dps[n][a]
  debug dpn[N][M]
  echo dps[N][M]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

