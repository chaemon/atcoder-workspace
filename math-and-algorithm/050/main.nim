const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(a:int, b:int):
  discard

when not DO_TEST:
  var a = nextInt()
  var b = nextInt()
  solve(a, b)
else:
  discard

