const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const USE_MONTGOMERY = false

const MOD = 998244353

#import atcoder/modint
import lib/math/modint_montgomery
type mint = modint_montgomery_998244353

#import atcoder/modint
#type mint = modint998244353

import atcoder/convolution, lib/math/combination
import lib/math/ntt, lib/math/formal_power_series

block:
  var a = newSeqUninitialized[int](12)

solveProc solve(N:int, M:int, a:seq[int]):
  proc calc(k:int):seq[mint] = # k個のボールを1, 2, ..., k連に分ける
    result = Seq[k + 1: mint(0)]
    for i in 1 .. k: # i連に分けるためにはk - i箇所を切る必要がある
      result[i] = mint.C(k - 1, k - i) * mint.rfact(i)

  var
    ct = Seq[N + 1: 0]
    P = mint(1)
  for i in N: ct[a[i]].inc
  var d = initDeque[seq[mint]]()
  for c in 1 .. N:
    if ct[c] > 0:
      d.addLast(calc(ct[c]))
      P *= mint.fact(ct[c])
  while d.len >= 2:
    d.addLast(convolution(d.popFirst, d.popFirst))
  var
    v = d.popFirst # 連の数
    a = newSeq[mint](N + 1)
  # i個の連 => i - 1個の切れ目 => N - 1 - (i - 1) = N - i個の同色箇所
  for i in 0 .. N:
    a[N - i] = v[i] * mint.fact(i)
  # a[i]にはi個以上の同色箇所ができる場合の数が入っている
  var a2, c = Seq[N + 1: mint(0)]
  for k in 0 .. N:
    if k mod 2 == 0:
      c[k] += mint.rfact(k)
    else:
      c[k] -= mint.rfact(k)
    a2[N - k] = mint.fact(k) * a[k]
  var
    b2 = c.convolution(a2) # b2[N - i]がb[i]
    b = Seq[N: mint(0)]
  for i in 0 .. N - 1:
    b[N - 1 - i] = b2[N - i] * P * mint.rfact(i)
  block:
    type F = FormalPowerSeries[mint]
    d := initDeque[(F, F)]()
    for i in 1 .. N - 1:
      let
        p = F.init(@[b[i]])
        q = F.init(@[mint(1), mint(-i)])
      d.addLast((p, q))
    while d.len >= 2:
      var (p, q) = (d.popFirst, d.popFirst)
      d.addLast((p[0] * q[1] + p[1] * q[0], p[1] * q[1]))
    var (p, q) = d.popFirst
    p.setLen(M + 1)
    q.setLen(M + 1)
    echo (p / q)[1 .. M].join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, M, a)
else:
  discard

