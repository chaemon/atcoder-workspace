const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search
import lib/math/combination

import atcoder/modint
type mint = modint998244353

solveProc solve(N:int, K:int):
  proc calc(a:int):bool =
    var a = a
    for i in K:
      a *= 3
      a = (a + 1) div 2
      if a > N: return false
    return true
  m := calc.maxRight(0..N+1)
  for i in 1..m:
    s := mint(0)
    for j in 0..K:
      s += mint.C(K, j) * ceilDiv(i, 2^j)
    debug i, s
  ans := mint(0)
  # 1 .. m
  for j in 0..K:
    s := mint(0)
    for i in 1..m:
      s += ceilDiv(i, 2^j)
    ans += mint.C(K, j) * s
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  discard

