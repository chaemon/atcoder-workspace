const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, K:int, C:seq[int], A:seq[seq[int]]):
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var C = newSeqWith(N, nextInt())
  var A = newSeqWith(N, newSeqWith(6, nextInt()))
  solve(N, K, C, A)
else:
  discard

