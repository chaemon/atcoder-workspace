const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, m:int, a:int, A:seq[int]):

  discard

when not DO_TEST:
  var N = nextInt()
  var m = nextInt()
  var a = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, m, a, A)
else:
  discard

