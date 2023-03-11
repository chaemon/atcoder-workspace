const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(X:int):
  discard

when not DO_TEST:
  var X = nextInt()
  solve(X)
else:
  discard

