const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int):
  var f = Seq[N + 1: mint(0)]
  f[0] = 0
  f[1] = 1
  for i in 2 .. N:
    f[i] = f[i - 1] + f[i - 2]
  echo f[N]
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

