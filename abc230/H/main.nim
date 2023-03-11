const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(W:int, K:int, w:seq[int]):
  return

when not DO_TEST:
  var W = nextInt()
  var K = nextInt()
  var w = newSeqWith(K, nextInt())
  solve(W, K, w)
else:
  discard

