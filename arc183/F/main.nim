when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(A:int, B:int, X:int, Y:int, N:int):
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var A = nextInt()
    var B = nextInt()
    var X = nextInt()
    var Y = nextInt()
    var N = nextInt()
    solve(A, B, X, Y, N)
else:
  discard

