const
  DO_CHECK = true
  DEBUG = true
include atcoder/extra/header/chaemon_header
import lib/math/ntt
import lib/math/formal_power_series
import lib/math/coef_of_generating_function

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

var x = initVar[mint]()

solveProc solve(N:int, K:int):
  var f:FormalPowerSeries[mint] = @[mint(1)]
  for t in 0 .. K << 1:
    var h = 1 - (f shl 1)
    if t > 0:
      let d = K div t
      h.resize(d + 1)
      var g = f / h
      g.resize(d + 1)
      f = g.move
    else:
      echo (f // h)[N]
  return

when not defined DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  discard

