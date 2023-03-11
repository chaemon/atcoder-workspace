const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int):
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

