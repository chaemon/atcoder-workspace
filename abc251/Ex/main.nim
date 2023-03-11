const
  DO_CHECK = false
  DEBUG = false
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 7
useStaticModInt(mint, MOD)

proc calc(N, m:int):mint =# C(N, 0) + C(N, 1) + ... + C(N, m - 1)をmod7で求める
  proc calcImpl(N, m, p: int):mint = 
    # p = 7^k
    # N = d * 7^k + nと分解(d < 7, n < 7^k)
    #debug "calcImpl: ", N, m, p
    if p == 1:
      doAssert N < 7
      result = 0
      for i in 0 ..< m: result += mint.C(N, i)
    else:
      let
        d = N div p
        n = N mod p
        q = m div p
        r = m mod p
      doAssert d in 0 ..< 7
      doAssert q in 0 ..< 7
      result = mint(0)
      for i in 0 ..< q:
        result += mint.C(d, i)
      #debug d, n, q, r, result
      result *= mint(2)^n
      if r > 0:
        result += calcImpl(n, r, p div 7) * mint.C(d, q)
  if m <= 0: return 0
  elif N <= m - 1: return mint(2)^N
  var p = 1
  while p <= N: p *= 7
  return calcImpl(N, m, p div 7)

#when defined DO_TEST:
#  const B = 1000
#  var cmb = Seq[B + 1: Seq[mint]]
#  for N in 0 .. B:
#    cmb[N].setLen(N + 1)
#    cmb[N][0] = 1
#    cmb[N][N] = 1
#    for r in 1 ..< N:
#      cmb[N][r] = cmb[N - 1][r] + cmb[N - 1][r - 1]
#
#  proc test(N, m:int) =
#    let c = calc(N, m)
#    var s = mint(0)
#    for i in 0 ..< min(m, N + 1):
#      s += cmb[N][i]
#    debug c, s
#    doAssert c == s
#
#  for N in 0 .. B:
#    for m in -3 .. N + 3:
#      debug N, m
#      test(N, m)

type S = object
  e: int
  a: mint

proc `*`(s, t:S):S = # s * t
  return S(e:s.e + t.e, a: s.a * t.a)

proc `*`(s:S, n:int):S = # s * n
  doAssert n > 0
  result = s
  var n = n
  while n mod 7 == 0:
    result.e.inc
    n = n div 7
  result.a *= n

proc `/`(s:S, n:int):S = # s / n
  result = s
  var n = n
  while n mod 7 == 0:
    result.e.dec
    n = n div 7
  result.a *= mint.inv(n mod 7)

proc `/`(s, t:S):S = # s / t
  doAssert s.e - t.e >= 0
  return S(e:s.e - t.e, a: s.a * mint.inv(t.a.val))

proc getVal(s:S):mint =
  if s.e > 0: return 0
  else: return s.a

proc getFact(n:int):S = # n * (n - 1) * ... * 1
  var n = n
  result = S(e:0, a:mint(1))
  if n == 0 or n == 1:return
  var r = n mod 7
  while r > 0:
    result = result * n
    r.dec
    n.dec
  # nは7の倍数
  let q = n div 7
  var u = getFact(q)
  u.e += q
  if q mod 2 == 1:
    u.a *= -1
  result = result * u

solveProc solve(N:int, M:int, K:int, a:seq[int], c:seq[int]):
  var K = K - 1
  # 段数は0, 1, 2, ..., N - 1である
  var r = 0
  var ans = Seq[K + 1: mint(0)]
  for t in M:
    # r ..< r + c[i]にa[i]がある
    # これをK段目に反映
    # (N - 1, r) => (K, 0)
    # N - 1 - K回のジャンプの中でr回左に行く
    # C(N - 1 - K, r) + C(N - 1 - K, r + 1) + ... + C(N - 1 - K, r + c[i] - 1)
    var
      b1 = r + c[t] - 1
      b0 = r - 1
      f1, f0:S
    if b1 >= 0 and N - K - b1 - 1 >= 0:
      f1 = getFact(N - 1 - K) / (getFact(N - 1 - K - b1) * getFact(b1))
    if b0 >= 0 and N - K - b0 - 1 >= 0:
      f0 = getFact(N - 1 - K) / (getFact(N - 1 - K - b0) * getFact(b0))
    var s = calc(N - 1 - K, r + c[t]) - calc(N - 1 - K, r)

    for i in K + 1:
      ans[i] += s * a[t]
      
      # C(N - 1 - K, b1)を引き
      if b1 >= 0 and N - K - b1 >= 0:
        s -= f1.getVal
      
      # C(N - 1 - K, b0)を足す
      if b0 >= 0 and N - K - b0 >= 0:
        s += f0.getVal


      # f1の値をC(N - 1 - K, b1)からC(N - 1 - K, b1 - 1)にする
      if N - K - b1 < 0:
        discard
      elif b1 - 1 in [0, N - 1 - K]:
        f1 = S(e:0, a:mint(1))
      elif b1 > 0:
        f1 = f1 * b1
        f1 = f1 / (N - K - b1)
      # f0の値をC(N - 1 - K, b0)からC(N - 1 - K, b0 - 1)にする
      if N - K - b0 < 0:
        discard
      elif b0 - 1 in [0, N - 1 - K]:
        f0 = S(e: 0, a:mint(1))
      elif b0 > 0:
        f0 = f0 * b0
        f0 = f0 / (N - K - b0)

      b1.dec
      b0.dec
    r += c[t]
  echo ans.join(" ")
  discard

when not defined DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var a = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    c[i] = nextInt()
  solve(N, M, K, a, c)
else:
  for c0 in 1..10:
    for c1 in 1 .. 10:
      for c2 in 1 .. 10:
        var c = @[c0, c1, c2]
        let N = c.sum
        let M = c.len
        let K = 3
        let a = @[3, 1, 4]
        debug N, M, K, a, c
        solve(N, M, K, a, c)
