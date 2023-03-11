const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/matrix

proc `+`(a, b:seq[mint]):seq[mint] =
  result = Seq[a.len:mint]
  for i in 0..<a.len: result[i] = a[i] + b[i]
proc `-`(a, b:seq[mint]):seq[mint] =
  result = Seq[a.len:mint]
  for i in 0..<a.len: result[i] = a[i] - b[i]
proc `*`(a:seq[mint], b:mint):seq[mint] =
  result = Seq[a.len:mint]
  for i in 0..<a.len: result[i] = a[i] * b

proc fwt[T](f:var seq[T]) =
  let n = f.len
  var i = 1
  while i < n:
    for j in 0..<n:
      if (j and i) == 0:
        let
          x = f[j]
          y = f[j or i];
        f[j] = x + y; f[j or i] = x - y
    i *= 2



proc ifwt(f:var seq[mint]) =
  let n = f.len
  var i = 1
  let inv2 = mint(1) / mint(2)
  while i < n:
    for j in 0..<n:
      if (j and i) == 0:
        let 
          x = f[j]
          y = f[j or i]
        f[j] = (x + y) * inv2
        f[j or i] = (x - y) * inv2
    i *= 2

proc `*=`(a:var seq[mint], b:seq[mint]) =
  var b = b
  fwt(a);fwt(b)
  for i in 0..<a.len:
    a[i] *= b[i]
  ifwt(a)

proc `*`(a, b:seq[mint]):seq[mint] =
  result = a
  result *= b

#proc z0():seq[mint] = Seq[2^16: mint(0)]
#
#proc u0():seq[mint] =
#  result = z0()
#  result[0] = 1

#type M = MatrixType(seq[mint], z0, u0)

solveProc solve(N:int, K:int, A:seq[int]):
  var a = Seq[2^16:mint(0)]
  for i in 0..<K: a[A[i]].inc
  var P = a
  P.fwt
  for i in P.len:
    if P[i] == 1:
      P[i] = N + 1
    else:
      P[i] = (1 - P[i]^(N + 1)) / (1 - P[i])
  P.ifwt
  
#  var A = M.init([[a, z0()], [u0(), u0()]])
#  var b = A^(N + 1) * M.initVector([u0(), z0()])
  var s = mint(0)
  var p = mint(1)
  for i in 0..N:
    s += p
    p *= K
#  echo s - b[1][0]
  echo s - P[0]
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt())
  solve(N, K, A)
#}}}

