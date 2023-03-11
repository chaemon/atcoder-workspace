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
  echo mint(2)^N * mint.C(N * 2, N) / (N + 1) * mint.fact(N)
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard
