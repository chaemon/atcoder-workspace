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
solveProc solve(N:int, M:int, L:seq[int], R:seq[int], X:seq[int]):
  Pred L, X # L[i] ..< R[i]
  var dp = Seq[N + 1, N + 1: mint(0)] # dp[a][b]: a ..< bのDP結果
  for i in N + 1:
    dp[i][i] = 1
  for d in 1 .. N:
    # 長さdのdpを計算する。
    var
      open, close = Seq[N: seq[int]]
      ct = Seq[N: 0]
    for m in M:
      # L[m] ..< R[m]がi ..< i + dに含まれる範囲
      # つまり、i <= L[m] and R[m] <= i + d
      let
        l = max(R[m] - d, 0)
        r = L[m] + 1
      # l ..< rではX[m]を追加
      if r <= l: continue
      open[l].add X[m]
      if r < N:
        close[r].add X[m]
    for i in N:
      for a in open[i]:
        ct[a].inc
      for a in close[i]:
        ct[a].dec
      let j = i + d
      if j > N: break
      dp[i][j] = 0
      for k in i ..< j:
        # kを中心にする
        if ct[k] != 0: continue
        dp[i][j] += dp[i][k] * dp[k + 1][j] * mint.C(d - 1, k - i)
  echo dp[0][N]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  var X = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt()
    R[i] = nextInt()
    X[i] = nextInt()
  solve(N, M, L, R, X)
else:
  discard

