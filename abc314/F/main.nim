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
solveProc solve(N:int, p:seq[int], q:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = newSeqWith(N-1, 0)
  var q = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    p[i] = nextInt()
    q[i] = nextInt()
  solve(N, p, q)
else:
  discard

