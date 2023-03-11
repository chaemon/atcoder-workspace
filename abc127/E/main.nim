const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, M:int, K:int):
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  solve(N, M, K)
else:
  discard

