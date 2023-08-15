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
solveProc solve(N:int):
  block:
    var N = N
    while N mod 2 == 0: N.div=2
    while N mod 3 == 0: N.div=3
    while N mod 5 == 0: N.div=5
    if N != 1:
      echo 0;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

