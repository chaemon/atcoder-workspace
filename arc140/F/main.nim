const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/math/matrix, lib/other/operator
import lib/math/combination

import atcoder/modint, atcoder/convolution
const MOD = 998244353
type mint = modint998244353

const op = getOperator(seq[mint]):
  zero() = @[mint(0)]
  unit() = @[mint(1)]
  proc add(a, b:seq[mint]):seq[mint] =
    result = newSeq[mint](max(a.len, b.len))
    for i in result.len: result[i] = 0
    for i in a.len: result[i] += a[i]
    for i in b.len: result[i] += b[i]
  mult(a, b) = a.convolution(b)

type MT = StaticMatrixType(seq[mint], op)
#type MT = DynamicMatrixType(seq[mint], op)

solveProc solve(N:int, M:int):
  proc calc(n:int):seq[mint] =
    var
      A = MT.init(
        [[@[mint(1), mint(1)], @[mint(0), mint(1)]], 
         [@[mint(1)]         , @[mint(0)]]])
      b = MT.init([@[mint(0), mint(1)], @[mint(1)]]) # f_1, f_0
    var v = ((A^n) * b)[1] # f_(n + 1), f_n
    return v
  var
    q = N div M
    r = N mod M
    d = initDeque[seq[mint]]()
    a0 = calc(q + 1)
    a1 = calc(q)
  ## r個がq + 1
  ## M - r個がq

  for i in r: d.addLast(a0)
  for i in M - r: d.addLast(a1)
  while d.len >= 2:
    d.addLast(convolution(d.popFirst, d.popFirst))
  var a = d.popFirst # a[i]はi連を実現する個数となる(Mになる個数がN - 1 - i)
  #doAssert a.len >= N + 1
  a.setLen(N + 1)
  for i in 1 .. N:
    a[i] *= mint.fact(i)
  var a2 = newSeqWith(N, mint(0))
  for i in 1..N:
    a2[N - i] = a[i]
  swap a, a2
  for n in a.len:
    a[n] *= mint.fact(n)
  var b = newSeqWith(a.len, mint(0))
  for i in b.len:
    if i mod 2 == 0:
      b[i] += mint.rfact(i)
    else:
      b[i] -= mint.rfact(i)
  b.reverse
  a = a.convolution(b)[^(1+N-1)..^1]
  for i in a.len:
    a[i] *= mint.rfact(i)
  echo a.join(" ")

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

