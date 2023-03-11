include atcoder/extra/header/chaemon_header

const MOD = 1000000007

import atcoder/modint
import atcoder/extra/math/combination

type mint = modint1000000007

proc mul(a, b:seq[mint]):auto =
  result = newSeq[mint](a.len + b.len - 1)
  for i in 0..<a.len:
    for j in 0..<b.len:
      result[i + j] += a[i] * b[j]

proc divide(a, b:seq[mint]):auto =
  var a = a
  assert(b.len == 2)
  assert(b[1] == 1)
  result = newSeq[mint](a.len - 1)
  for i in countdown(a.len - 1, 1):
    result[i - 1] = a[i]
    a[i - 1] -= a[i] * b[0]
    a[i] = mint(0)
  assert(a[0] == 0)

proc eval(f:seq[mint], x:mint):auto =
  result = mint(0)
  for i in countdown(f.len - 1, 0):
    result *= x
    result += f[i]

proc integral(f:seq[mint]):auto =
  result = newSeq[mint](f.len + 1)
  for i in 0..<f.len:
    result[i + 1] = mint.inv(i + 1) * f[i]

proc solve(N:int, L:seq[int], R:seq[int]) =
  var
    v = newSeq[(int, int, int)]()
    p = @[mint(1)]
    prod = mint(1)
  var maxL = -int.inf
  for i in 0..<N:
    v.add((L[i], +1, i))
    v.add((R[i], -1, i))
    maxL.max=L[i]
  v.sort()
  var i = 0
  var E = mint(0)
  while true:
    let x = v[i][0]
    while i < v.len and v[i][0] == x:
      let i0 = v[i][2]
      if v[i][1] == -1:
        p = divide(p, @[-mint(L[i0]), mint(1)])
        prod /= R[i0] - L[i0]
      else:
        p = mul(p, @[-mint(L[i0]), mint(1)])
        prod *= R[i0] - L[i0]
      i.inc
    if i == v.len: break # end
    if x < maxL: continue
    let y = v[i][0]
    let
      X = x.mint
      Y = y.mint
    let pi = p.integral()
    E += (Y * p.eval(Y) - X * p.eval(X) - pi.eval(Y) + pi.eval(X)) / prod
  var P = mint(1)
  for i in 0..<N: P *= (R[i] - L[i])
  echo E * P * mint.fact(N + 1)
  return

# input part {{{
block:
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, L, R)
#}}}
