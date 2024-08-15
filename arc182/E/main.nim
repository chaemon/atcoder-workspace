when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 5
type mint = modint5
solveProc solve(N:int, M:int, C:int, K:int, A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var C = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, C, K, A)
else:
  discard

