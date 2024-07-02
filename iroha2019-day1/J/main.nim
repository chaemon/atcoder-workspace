when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007
solveProc solve(Q:int, N:seq[int], K:seq[int]):
  discard

when not defined(DO_TEST):
  var Q = nextInt()
  var N = newSeqWith(Q, 0)
  var K = newSeqWith(Q, 0)
  for i in 0..<Q:
    N[i] = nextInt()
    K[i] = nextInt()
  solve(Q, N, K)
else:
  discard

