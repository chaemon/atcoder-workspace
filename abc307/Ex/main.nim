when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 1
type mint = modint1
solveProc solve(L:int, W:int, S:string, P:string):
  discard

when not defined(DO_TEST):
  var L = nextInt()
  var W = nextInt()
  var S = nextString()
  var P = nextString()
  solve(L, W, S, P)
else:
  discard

