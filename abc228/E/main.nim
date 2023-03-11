const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, K:int, M:int):
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var M = nextInt()
  solve(N, K, M)
else:
  discard

