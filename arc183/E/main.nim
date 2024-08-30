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
solveProc solve(N:int, M:int, P:seq[int], A:seq[int], B:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  var A = newSeqWith(M, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, P, A, B)
else:
  discard

