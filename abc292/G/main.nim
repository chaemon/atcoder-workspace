when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

converter toOpt[T](a:T):Option[T] =
  a.some

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, S:seq[string]):
  # インデックスi ..< jのk桁目までは同じ値
  # k桁目の最小値はdとする場合の単調増加にする場合の数
  dp := Seq[N + 1, N + 1, M + 1, 10 + 1: Option[mint]]
  proc calc(i, j, k, d:int):mint =
    ret =& dp[i][j][k][d]
    if ret.isSome: return ret.get
    if i == j: ret = mint(1)
    elif d == 10: ret = mint(0)
    elif k == M:
      if j - i <= 1:
        ret = mint(1)
      else:
        ret = mint(0)
    else:
      s := mint(0)
      for i2 in i .. j:
        # i ..< i2のk桁目をdとする
        s += calc(i, i2, k + 1, 0) * calc(i2, j, k, d + 1)
        if i2 == j: break
        if S[i2][k] != '?' and S[i2][k] - '0' != d: break
      ret = s
    return ret.get
  echo calc(0, N, 0, 0)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, M, S)
else:
  discard

