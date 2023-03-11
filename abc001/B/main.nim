const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 5
type mint = modint5

solveProc solve(m:int):
  return

when not DO_TEST:
  var m = nextInt()
  solve(m)
else:
  discard

