when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(A:int, B:int, C:int, D:int, E:int, F:int):
  echo mint(A) * B * C - mint(D) * E * F
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  var E = nextInt()
  var F = nextInt()
  solve(A, B, C, D, E, F)
else:
  discard

