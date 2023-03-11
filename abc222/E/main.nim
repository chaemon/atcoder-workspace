const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, K:int, A:seq[int], U:seq[int], V:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(M, nextInt())
  var U = newSeqWith(N-1, 0)
  var V = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, M, K, A, U, V)
else:
  discard

