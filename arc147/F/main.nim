const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 2
type mint = modint2

# Failed to predict input format
solveProc solve():
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

