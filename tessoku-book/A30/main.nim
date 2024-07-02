when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007
solveProc solve(n:int, r:int):
  echo mint.C(n, r)
  discard

when not defined(DO_TEST):
  var n = nextInt()
  var r = nextInt()
  solve(n, r)
else:
  discard

