const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1
type mint = modint1

solveProc solve(N:int, Q:int, X:int, W:seq[int], K:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var X = nextInt()
  var W = newSeqWith(N, nextInt())
  var K = newSeqWith(Q, nextInt())
  solve(N, Q, X, W, K)
else:
  discard

