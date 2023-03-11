const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, L:seq[int], R:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var L = newSeqWith(N, nextInt())
  var R = newSeqWith(M, nextInt())
  solve(N, M, L, R)
else:
  discard

