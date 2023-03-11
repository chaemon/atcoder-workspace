when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

import atcoder/modint
include lib/header/chaemon_header
import lib/math/combination_table

type mint = modint

solveProc solve(N: int, M: int):
  mint.setMod(M)
  var pow2_table = Seq[N^2 + 1: mint]
  pow2_table[0] = 1
  for i in 1 .. N^2:
    pow2_table[i] = pow2_table[i - 1] * 2
  var pow_table = Seq[N + 1, N + 1: mint]
  for a in 1 .. N:
    #let t = mint(2)^a - 1
    let t = pow2_table[a] - 1
    var p = t
    for b in 1 .. N:
      pow_table[a][b] = p
      p *= t
  var dp = Seq[N, N: mint(0)] # すでに選んだ頂点, 直前の頂点
  dp[1][1] = 1
  for n in 1 .. N - 1:
    # すでにn頂点選ぶ
    for a in 1 .. n:
      # 内a頂点が直前
      for b in 1 .. N - 1 - n:
        # 次はb頂点
        var s = dp[n][a] * mint.C(N - 1 - n, b)
        # b頂点間の辺は何でもよい
        let t = (b * (b - 1)) div 2
        #s *= mint(2)^t
        s *= pow2_table[t]
        # a頂点→b頂点でa頂点のどれか一つと結ばれる
        #s *= (mint(2)^a - 1)^b
        s *= pow_table[a][b]
        dp[n + b][b] += s
        discard
  ans := mint(0)
  for a in 1 .. N - 1:
    #ans += dp[N - 1][a] * (mint(2)^a - 1)
    ans += dp[N - 1][a] * (pow2_table[a] - 1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

