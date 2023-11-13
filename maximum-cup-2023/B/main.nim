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
solveProc solve(N:int, Q:int, a:seq[int], d:seq[int], k:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(Q, 0)
  var d = newSeqWith(Q, 0)
  var k = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    d[i] = nextInt()
    k[i] = nextInt()
  solve(N, Q, a, d, k)
else:
  discard

