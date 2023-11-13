when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, X:int):
  # 0 ..< Nの値を順番にインデックスと順列の値をマッチングする
  let
    B = 1 << X
    D = 1 << (X - 1)
  var dp = Seq[N + 1, B, B: mint(0)]
  # dp[n][b1][b2]において
  # b1は直近でインデックスとして決まっていないもの
  # b2は直近で順列として決まっていないもの
  # nはインデックスのうち決まっていないもの。nが決まれば順列として決まっていないもの数は決まる
  #
  # 0, 1, ..., X - 1
  dp[0][0][0] = 1
  for i in N:
    var dp2 = Seq[N + 1, B, B: mint(0)]
    # n, b, c, m
    for n in 0 .. N:
      for b in B:
        let
          n1 = n + (b & 1)
          b1 = (b >> 1)
        for c in B:
          let
            m = n + b.popCount - c.popCount
          if m < 0: continue
          let
            m1 = m + (c & 1)
            c1 = (c >> 1)
          # 新たな1ビットについて
          # インデックス, 順列を既存のものとマッチング
          if n1 - 1 in 0 .. N:
            dp2[n1 - 1][b1][c1] += dp[n][b][c] * n1 * m1
          # インデックスだけマッチング
          if n1 in 0 .. N:
            dp2[n1][b1][c1 | D] += dp[n][b][c] * m1
          # 順列だけマッチング
          if n1 - 1 in 0 .. N:
            dp2[n1 - 1][b1 | D][c1] += dp[n][b][c] * n1
          # 両方マッチングしない
          if n1 in 0 .. N:
            dp2[n1][b1 | D][c1 | D] += dp[n][b][c]
    dp = dp2.move
  echo dp[0][0][0]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  solve(N, X)
else:
  discard

