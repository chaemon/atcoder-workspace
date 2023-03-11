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

solveProc solve(N:int, K:int):
  var
    t:int
    c:mint
    ans = mint(0)
  if K >= N:
    t = 0
    c = mint.C_large(K + t + 1, N + 1)
  else:
    t = N - K
    c = 1
  while true:
    ans += mint.C(N, t) * c
    c /= K + t - N + 1
    t.inc
    if t > N: break
    c *= K + t + 1
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  discard

