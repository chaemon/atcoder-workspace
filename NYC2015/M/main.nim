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
solveProc solve(N:int, K:int, a:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(K, nextInt())
  solve(N, K, a)
else:
  discard

