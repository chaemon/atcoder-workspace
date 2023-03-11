const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(K:int, N:int):
  discard

when not DO_TEST:
  var K = nextInt()
  var N = nextInt()
  solve(K, N)
else:
  discard

