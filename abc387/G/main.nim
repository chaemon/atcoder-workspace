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

import atcoder/extra/math/ntt
import atcoder/extra/math/formal_power_series
import lib/math/combination
import lib/math/composition_kinoshita_li
import lib/math/newton_method

when false:
  var
    F = initFormalPowerSeries[mint](@[3, 1, 4])
    G = initFormalPowerSeries[mint](@[1, 5, 9])
    H = initFormalPowerSeries[mint](@[2, 6, 5])
  # f(g(h(x)))
  echo composition(F, composition(G, H))
  echo composition(composition(F, G), H)

  # G(f) = F * f - 1 = 0
  proc calc_g(f:FormalPowerSeries[mint], d:int):auto =
    var
      g = F * f  - 1
      dgdf = F
    g.resize(d)
    dgdf.resize(d)
    return (g, dgdf)
  echo newtonMethod(calc_g, 1 / mint(3), 10)
  echo 1 / F

import lib/math/eratosthenes

solveProc solve(N:int):
  var
    es = initEratosthenes()
    x = initFormalPowerSeries[mint](@[0, 1])
    G = initFormalPowerSeries[mint](N + 1)
    half = 1 / mint(2)
  G[1].inc
  for p in 3 .. N:
    if es.isPrime(p): G[p] = half
  var dG = G.diff
  proc calc_g(F:FormalPowerSeries[mint], d:int):auto =
    var
      F1 = x * exp(F, d)
    #debug G, dG, F1, d
    var
      g = composition(G, F1, d) - F
      dgdf = F1 * composition(dG, F1, d) - 1
    g.resize(d)
    dgdf.resize(d)
    #debug F, d, g, dgdf
    return (g, dgdf)
  let a = newtonMethod(calc_g, 0, N + 1)
  echo a[N] * mint.fact(N - 1)
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

