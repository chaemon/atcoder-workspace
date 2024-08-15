when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, Q:int, P:seq[int], V:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var P = newSeqWith(Q, 0)
  var V = newSeqWith(Q, 0)
  for i in 0..<Q:
    P[i] = nextInt()
    V[i] = nextInt()
  solve(N, Q, P, V)
else:
  discard

