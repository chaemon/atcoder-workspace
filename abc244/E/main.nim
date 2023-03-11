const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, K:int, S:int, T:int, X:int, U:seq[int], V:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var S = nextInt()
  var T = nextInt()
  var X = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, M, K, S, T, X, U, V)
else:
  discard

