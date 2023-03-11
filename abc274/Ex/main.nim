when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

import lib/other/bitutils
import std/random
import lib/other/binary_search

import lib/other/bitset
import lib/other/binary_search

#echo initBitSet[12]

type BS = BitSet[128]

type P = distinct uint64

proc `$`(p:P):string {.borrow.}
proc `==`(a, b:P):bool {.borrow.}

# X64 + X33 + X30 + X26 + X25 + X24 + X23 + X22 + X21 + X20 + X18 + X13 + X12 + X11 + X10 + X7 + X5 + X4 + X2 + X + 1
#var mf = block:
#  var
#    f = initBitSet[128]()
#    p = [64, 33, 30, 26, 25, 24, 23, 22, 21, 20, 18, 13, 12, 11, 10, 7, 5, 4, 2, 1, 0]
#  for i in p:
#    f[i] = 1
#  f
#
#  X63 + X24 + X23 + X22 + X17 + X16 + X15 + X11 + X9 + X8 + X4 + X3 + X2 + X + 1
var mf = block:
  var
    f = initBitSet[128]()
    p = [63, 24, 23, 22, 17, 16, 15, 11, 9, 8, 4, 3, 2, 1, 0]
  for i in p:
    f[i] = 1
  f

proc `+`(p, q:P):P = P(p.uint64 xor q.uint64)
proc `-`(p, q:P):P = p + q
proc mul(p, q:P):BS =
  var
    b = BS.init(q.uint64)
    r = BS.init()
  for i in 64:
    if p.uint64[i] == 1:
      r.xor= b
    b = b shl 1
  return r

proc divmod(p, q:BS):(BS, BS) =
  var
    qi = q.fastLog2()
    b = q shl (128 - qi - 1)
    p = p
    d = BS.init()
  for i in qi ..< 128 << 1:
    if p[i] == 1:
      p = p xor b
      d[i - qi] = 1
    b = b shr 1
  return (d, p)
proc divmod(p, q:P):(P, P) =
  var
    p = p.uint64
    q = q.uint64
    qi = q.fastLog2()
    b = q shl (64 - qi - 1)
    d = 0.uint64
  for i in qi ..< 64 << 1:
    if p[i] == 1:
      p = p xor b
      d[i - qi] = 1
    b = b shr 1
  return (P(d), P(p))

proc `*`(p, q:P):P =
  let (d, m) = divMod(mul(p, q), mf)
  return P(m.data[0])

proc inv(p:P):P =
  proc f(a, b: P, x, y: var P):P =
    var
      a = a
      b = b
      d = a
    if b.uint64 != 0:
      let (q, m) = (a.divMod(b))
      d = f(b, m, y, x)
      y = y - q * x
    else:
      x = P(1)
      y = P(0)
    return d
  var
    u = P(mf.data[0])
    x, y: P
  let g = f(p, u, x, y)
  doAssert p * x + u * y == g
  doAssert g.uint64 == 1
  return x

proc `^`(x:P, n:int):P =
  if n == 0: return P(1)
  var p = x^(n div 2)
  p = p * p
  if n mod 2 == 1:
    p = p * x
  return p

# Failed to predict input format
solveProc solve(N, Q:int, A:seq[int]):
  var
    rnd = initRand(2022)
    cs = Seq[N + 1: P]
    b = P(rnd.next())
    binv = b.inv
    s = P(0)
    pw = Seq[N + 1: P]
  pw[0] = P(1)
  for i in N:
    pw[i + 1] = pw[i] * binv
  var p = P(1)
  cs[0] = P(0)
  cs[0] = s
  for i in N:
    p = p * b
    s = s + p * P(A[i])
    cs[i + 1] = s
  proc subArray(a, b:int):P = # a ..< b
    (cs[b] - cs[a]) * pw[a]
  for _ in Q:
    var a, b, c, d, e, f = nextInt()
    a.dec;c.dec;e.dec
    let
      l = b - a
      r = f - e
    proc g(n:int):bool =
      subArray(a, a + n) + subArray(c, c + n) + subArray(e, e + n) == P(0)
    let m = min(l, r)
    let u = g.maxRight(0 .. m)
    if u == m:
      if l >= r: echo NO
      else: echo YES
    else:
      let
        x = A[a + u] xor A[c + u]
        y = A[e + u]
      if x < y: echo YES
      elif x > y: echo NO
      else: doAssert false
  #doAssert false

when not defined(DO_TEST):
  let N, Q = nextInt()
  var A = Seq[N: nextInt()]
  solve(N, Q, A)
else:
  discard

