const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, D:int):
  return

when not DO_TEST:
  var N = nextInt()
  var D = nextInt()
  solve(N, D)
else:
  discard

