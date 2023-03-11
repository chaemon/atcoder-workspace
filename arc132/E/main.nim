const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(n:int, s:string):
  discard

when not DO_TEST:
  var n = nextInt()
  var s = nextString()
  solve(n, s)
else:
  discard

