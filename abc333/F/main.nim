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
  var
    p = @[mint(1)]
    half = mint(1) / mint(2)
  for n in 1 .. N - 1:
    var
      q = Seq[n + 1: mint(0)]
      q0 = mint(0)
      s = mint(1) / mint(4)
    for i in 0 ..< n << 1:
      q0 += s * p[i]
      s *= half
    q0 /= (1 - mint(1) / mint(2)^(n+1))
    q[0] = q0
    q[n] = 2 * q[0]
    for i in 1 .. n - 1 << 1:
      q[i] = 2 * q[i + 1] - p[i]
    swap p, q
  echo p.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

