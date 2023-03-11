const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
type mint = modint998244353


solveProc solve(N:int):
  echo mint(N)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

