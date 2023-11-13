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
  let
    half = mint(1) / 2
    NMAX = (N * (N - 1)) div 2
  var
    dp_colored = Seq[N + 1, NMAX + 1: mint(0)] # 白黒色分けした状態での個数
    dp_colored_unique = Seq[N + 1, NMAX + 1: mint(0)] # 白黒色分けして連結成分1つの個数
    dp_unique = Seq[N + 1, NMAX + 1: mint(0)] # 塗り分けなしの二部グラフの個数で連結成分1つ
    dp = Seq[N + 1, NMAX + 1: mint(0)] # 塗り分けなしの二部グラフ
  for n in 1 .. N:
    # 頂点数がn - 1 -> n
    let m_max = (n * (n - 1)) div 2
    if n == 1:
      dp_colored[1][0] = 2
      dp_colored_unique[1][0] = 2
      dp_unique[1][0] = 1
      dp[1][0] = 1
      dp[0][0] = 1
    else:
      # dp_colored[n]を計算
      for m in 0 .. m_max:
        var s = mint(0)
        for b in 0 .. n:
          s += mint.C(n, b) * mint.C(b * (n - b), m)
        dp_colored[n][m] = s
      # dp_colored_unique[n]を計算
      for m in 0 .. m_max:
        var s = dp_colored[n][m]
        for k in 1 ..< n:
          # k個の集合Sを作る
          for m1 in 0 .. m:
            # m1本がSに含まれる
            s -= mint.C(n - 1, k - 1) * dp_colored_unique[k][m1] * dp_colored[n - k][m - m1]
        dp_colored_unique[n][m] = s
        dp_unique[n][m] = s * half
        # dp[n]を計算
        # 最初の連結成分のサイズをkとする
        var t = mint(0)
        for k in 1 .. n:
          for m1 in 0 .. m:
            t += mint.C(n - 1, k - 1) * dp_unique[k][m1] * dp[n - k][m - m1]
        dp[n][m] = t
  var ans = mint(0)
  for m in 0 .. NMAX:
    # M本からm種類全部出るものを数える
    for k in 0 .. m: # k種類しか出ないものを数える
      let u = mint.C(m, k) * mint(k * 2)^M * dp[N][m]
      if (m - k) mod 2 == 0:
        ans += u
      else:
        ans -= u
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

