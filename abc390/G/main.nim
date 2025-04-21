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
import lib/math/combination

type S = object
  n, d: FormalPowerSeries[mint]

solveProc solve(N:int):
  var v = initDeque[S]()
  for i in N:
    var
      nd = 0
      k = i + 1
    block:
      var u = k
      while u > 0:
        u.div=10
        nd.inc
    # k = i + 1
    # k / (1 + 10^nd * x)
    var
      n = initFormalPowerSeries[mint](@[k])
      d = initFormalPowerSeries[mint](@[mint(1), mint(10)^nd])
    v.addLast S(n:n, d:d)
  while v.len >= 2:
    var x, y = v.popFirst
    v.addLast S(n: x.n * y.d + y.n * x.d, d: x.d * y.d)
  var
    p = v[0].move
    ans = mint(0)
  for d, c in p.n:
    # c * x^d => c * d!
    ans += c * mint.fact(d) * mint.fact(N - 1 - d)
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

