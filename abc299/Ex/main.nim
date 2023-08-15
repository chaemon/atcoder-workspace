when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/math/ntt
import lib/math/formal_power_series
import lib/math/formal_power_series_rational

#import lib/math/coef_of_generating_function

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const A = 10^9

solveProc solve(R:int):
  var x = initVar[mint]()
  let
    inv6 = mint(1) / 6
    p:FormalPowerSeries[mint] = (x + x^2 + x^3 + x^4 + x^5 + x^6) * inv6
    f = 1 - p
  # f(x, y) = 1 / (1 - y * (x + x^2 + ... + x^6) / 6)
  proc calc_f(R:int):tuple[P, Q: seq[mint]] =
    # f(x, 1)のx^(R + k * A)を取り出した母関数を計算
    var
      d = 6
      r = R
    var v:seq[mint]
    for i in d * 2 + 10:
      v.add (@[mint(1)] // f)[r]
      #v.add linearRecurrence(@[mint(1)], f, r)
      r += A
    return v.getGeneratingFunction()
  # df(x, y) = (x + x^2 + ... + x^6) / 6 / (1 - y * (x + ... + x^6)/6)^2
  proc calc_df(R:int):tuple[P, Q:seq[mint]] =
    var
      d = 12
      r = R
    var v:seq[mint]
    for i in d * 2 + 10:
      v.add (p // (f * f))[r]
      #v.add linearRecurrence(p, f * f, r)
      r += A
    return v.getGeneratingFunction()
  block:
    # P = 0のときのf(x, y)
    # Q = Rのときのf(x, y)
    var
      P = calc_f(R)
      Q = calc_f(0)
      dP = calc_df(R)
      dQ = calc_df(0)
      # mで通分
      m = P.Q * Q.Q * Q.Q * dP.Q * dQ.Q
      # (dP * Q - P * dQ) / Q^2
    var p, q: FormalPowerSeries[mint]
    p += (dP.P * Q.P * m) div (dP.Q * Q.Q)
    p -= (P.P * dQ.P * m) div (P.Q * dQ.Q)
    q += (Q.P * Q.P * m) div (Q.Q * Q.Q)
    var ct = 0
    while q(1) == 0:
      doAssert p(1) == 0
      p = p div (1 - x)
      q = q div (1 - x)
      ct.inc
    echo p(1) / q(1)
  discard

when not defined(DO_TEST):
  var R = nextInt()
  solve(R)
else:
  discard

