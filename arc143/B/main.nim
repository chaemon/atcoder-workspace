const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(N:int):
  ans := mint(0)
  for M in 0 ..< N^2:
    let
      l = M
      r = N^2 - 1 - M # M + 1 .. N^2 - 1
    if l < N - 1 or r < N - 1: continue
    ans += mint.P(l, N - 1) * mint.P(r, N - 1) * (N^2) * mint.fact((N - 1)^2)
  echo mint.fact(N^2) - ans
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

