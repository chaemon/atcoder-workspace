when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import lib/math/formal_power_series
import lib/math/combination

proc multNaive[T](a, b:seq[T]):seq[T] =
  result = newSeq[T](a.len + b.len - 1)
  for i in 0 ..< a.len:
    for j in 0 ..< b.len:
      result[i + j] += a[i] * b[j]
proc divNaive[T](a, b:seq[T], deg = -1):seq[T] = 
  var deg = if deg == -1: a.len else: deg
  result = newSeq[T](deg)
  # a = b * result
  var b0inv = b[0].inv
  for i in 0 ..< deg:
    var u = a[i]
    for j in 1 ..< min(i + 1, b.len):
      u -= b[j] * result[i - j]
    u *= b0inv
    result[i] = u
  #debug a, b, result

solveProc solve(N:int, K:int, E:seq[int]):
  let M = E.max
  var f = initFormalPowerSeries[mint](M + 1)
  var x = initVar[mint]()
  #var f = newSeq[mint](M + 1)
  f[0] = 1
  for i in N:
    f = f / (1 - x)
    #f = f.divNaive(@[mint(1), -mint(1)])
  ans := mint(0)
  for i in 0 .. N:
    # f = (1 / (1 - x^2))^i(1 / (1 - x))^(N - i)となる
    var p = mint.C(N, i)
    for i in K:
      p *= f[E[i]]
    if i mod 2 == 0:
      ans += p
    else:
      ans -= p
    f = f.divNaive(1 + x)
    # ループが終わったら(1 - x) / (1 - x^2) = 1 / (1 + x)をかける
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var E = newSeqWith(K, nextInt())
  solve(N, K, E)
else:
  discard

