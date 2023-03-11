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

import lib/math/combination

const B = 2 * 10^6 + 10

var
  a = Seq[B: mint]
  vis = Seq[B: false]

proc fact2(n:int):mint =
  if vis[n]: return a[n]
  if n == 1 or n == 0:
    return 1
  else:
    vis[n] = true
    a[n] = n * fact2(n - 2)
    return a[n]

solveProc solve(N:int):
  if N <= 2:
    echo 1;return
  echo mint(4)^(N - 2) * (mint(N)^2 - 3) * fact2(2 * N - 5) / (mint(2)^(N - 2) * mint.fact(N - 1))
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    solve(N)
else:
  discard

