when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, p:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = newSeqWith(N-2+1, nextInt())
  solve(N, p)
else:
  discard

