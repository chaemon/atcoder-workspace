const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(T:string, K:int):
  discard

when not defined(DO_TEST):
  var T = nextString()
  var K = nextInt()
  solve(T, K)
else:
  discard

