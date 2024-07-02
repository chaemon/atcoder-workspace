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

import lib/math/ntt
import lib/math/formal_power_series
import lib/math/formal_power_series_rational

solveProc solve(N:int, A:seq[int]):
  var
    x = initVar[mint]()
    d = initDeque[FormalPowerSeries[mint]]()
    r = initDeque[RationalFormalPowerSeries[mint]]()
  for i in N:
    d.addLast(1 + A[i] * x)
    r.addLast((A[i] * (A[i] - 1) * x) // (1 + A[i] * x))
  while d.len >= 2:
    var p, q = d.popFirst()
    d.addLast(p * q)
  while r.len >= 2:
    var p, q = r.popFirst()
    r.addLast(p + q)
  var
    P = (d[0] * r[0].num) / r[0].den
    Asum = A.sum
    S = mint(Asum)
    f = mint(1)
    ans = mint(0)
  for i in 1 .. N:
    S *= Asum - i
    f *= i
    ans += P[i] * f / S * (i + 1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

