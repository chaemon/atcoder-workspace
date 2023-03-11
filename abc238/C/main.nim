const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int):
  var ans = mint(0)
  for d in 1..18:
    var
      L = 10^(d - 1)
      R = 10^d
    if N < L: break
    R.min = N + 1
    let d = R - L
    ans += (mint(1) + d) * d / 2
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

