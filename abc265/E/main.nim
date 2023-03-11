const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
const B0 = 302

var dp:array[B0, array[B0, array[B0, mint]]]

solveProc solve(N:int, M:int, A:int, B:int, C:int, D:int, E:int, F:int, X:seq[int], Y:seq[int]):
  for i in B0:
    for j in B0:
      for k in B0:
        dp[i][j][k] = 0
  dp[0][0][0] = 1
  var p = initSet[(int, int)]()
  for i in M: p.incl (X[i], Y[i])
  ans := mint(0)
  for i in 0 .. N:
    for j in 0 .. N:
      for k in 0 .. N:
        if i + j + k > N:
          continue
        let
          X = i * A + j * C + k * E
          Y = i * B + j * D + k * F
        if (X, Y) in p:
          continue
        if i + j + k == N:
          ans += dp[i][j][k]
        dp[i + 1][j][k] += dp[i][j][k]
        dp[i][j + 1][k] += dp[i][j][k]
        dp[i][j][k + 1] += dp[i][j][k]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  var E = nextInt()
  var F = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, A, B, C, D, E, F, X, Y)
else:
  discard

