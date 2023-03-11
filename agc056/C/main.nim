const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 2
type mint = modint2

solveProc solve(N:int, M:int, L:seq[int], R:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, M, L, R)
else:
  discard

