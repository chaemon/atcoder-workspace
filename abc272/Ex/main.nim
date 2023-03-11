when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/ntt
import lib/math/formal_power_series

import lib/other/fold

import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc subproduct_tree*[T](xs:seq[T]):seq[FormalPowerSeries[T]] =
  let n = xs.len
  var k = 1
  while k < n: k = k shl 1
  var g = newSeqWith(2 * k, initFormalPowerSeries[T](@[T(1)]))
  for i in 0 ..< n: g[k + i] = initFormalPowerSeries[T](@[-xs[i], T(1)])
  var i = k
  while i > 1:
    i.dec
    g[i] = g[i shl 1] * g[(i shl 1) or 1]
  return g

proc multipoint_evaluation*[T](f:FormalPowerSeries[T], xs: seq[T]):seq[T] =
  var
    g = subproduct_tree(xs)
    m = xs.len
    k = g.len div 2
  g[1] = f mod g[1]
  for i in 2 ..< k + m: g[i] = g[i shr 1] mod g[i]
  var ys = initFormalPowerSeries[T](m)
  for i in 0 ..< m:
    ys[i] = if g[k + i].len == 0: T(0) else: g[k + i][0]
  return ys

solveProc solve(N:int, A:seq[int]):
  var A = A
  for a in A.mitems: a.inc
  A.sort
  # f_n(x)はn次の多項式
  # g_n(x) = f_n(x) * exp(1 / x)とする
  #
  # x <- 1 / xとしてN + 1個とる
  # x^Nをかけると逆順になる
  # [x^k]g_N(x) = (A[N - 1] - k + 1)*(A[N - 2] - (k - 1) + 1)*(A[N - 3] - (k - 2) + 1) * ... * (A[0] - k + N) * [[x^(k - N)]] exp(1 / x)
  # k = 0, 1, 2, ..., Nの値を取る
  var v: seq[FormalPowerSeries[mint]]
  for i in 0 ..< N:
    v.add initFormalPowerSeries[mint]([A[N - 1 - i] + i + 1, -1])
  var h = fold_associative(v, (a, b:FormalPowerSeries[mint]) => a * b)
  var xs:seq[mint]
  for i in 0 .. N: xs.add mint(i)
  var g = initFormalPowerSeries[mint](h.multipoint_evaluation(xs))
  for k in 0 .. N:
    g[k] *= mint.invFact(N - k)
  g.reverse
  var ex = initFormalPowerSeries[mint](N + 1)
  for i in 0 .. N:
    if i mod 2 == 0:
      ex[i] = mint.invFact(i)
    else:
      ex[i] = -mint.invFact(i)
  var f = g * ex
  f = f[0 .. N].reversed
  #block:
  #  var dp = @[mint(1)]
  #  for a in A:
  #    var dp2 = dp & mint(0)
  #    for i in dp.len:
  #      dp2[i + 1] += dp[i] * (a - i)
  #    dp = dp2.move
  #  debug dp, f
  for i in 0 .. N:
    f[i] *= mint.fact(N - i)
  # ちょうどk個で条件をみたすものがあるとき(求めたい母関数をp(x)とする)
  # 各項をk!で割ったものをp'(x)とする
  # l(<= k)個の部分ではC(k, l)回重複でカウントされている
  # つまりp'(x) * exp(x) = f'(x)
  block:
    for i in 0 .. N:
      f[i] *= mint.fact(i)
    f.reverse
    var ex = initFormalPowerSeries[mint](N + 1)
    for i in 0 .. N:
      if i mod 2 == 0:
        ex[i] = mint.invFact(i)
      else:
        ex[i] = -mint.invFact(i)
    f = f * ex
    f = f[0 .. N]
    f.reverse
    for i in 0 .. N:
      f[i] *= mint.invfact(i)
  ans := mint(0)
  for i in 0 .. N:
    if i mod 2 == 0:
      ans += f[i]
  ans *= mint.invFact(N)
  ans *= N
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

