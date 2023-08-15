when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

import lib/math/ntt
include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination
import lib/math/formal_power_series

solveProc solve(N:int, K:int, S:seq[int]):
  var a = initFormalPowerSeries[mint](N)
  for i in K:
    let k = S[i] - 1
    a[k] += mint.invfact(k)
  a = a.pow(N)
  echo a[N - 2] * mint.fact(N - 2)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var S = newSeqWith(K, nextInt())
  solve(N, K, S)
else:
  discard

