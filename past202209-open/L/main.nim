when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 3
type mint = modint3
solveProc solve(N:int, M:int, A:seq[int], P:seq[int], Q:seq[int], L:seq[int], R:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var P = newSeqWith(M, 0)
  var Q = newSeqWith(M, 0)
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    P[i] = nextInt()
    Q[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, M, A, P, Q, L, R)
else:
  discard

