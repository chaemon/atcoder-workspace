const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/math/combination_table

solveProc solve(n:int, r:int):
  echo int.C(n, r)
  discard

when not DO_TEST:
  var n = nextInt()
  var r = nextInt()
  solve(n, r)
else:
  discard

