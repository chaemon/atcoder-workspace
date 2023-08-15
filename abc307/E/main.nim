when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, M:int):
  var
    a = Seq[N + 1: mint]
    p = mint(M) * (M - 1)
  # a[i]: i人で隣り合う人が違う数

  a[2] = p
  for i in 3 .. N:
    p *= M - 1
    # pは両側を考慮しないで隣り合う人が違う数
    # つまり両側が同じ場合を引く。これはa[i - 1]である
    a[i] = p - a[i - 1]
  echo a[N]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

