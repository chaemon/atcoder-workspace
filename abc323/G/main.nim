when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/matrix
import lib/math/characteristic_polynomial
import std/random
import lib/math/ntt
import lib/math/formal_power_series
import lib/math/polynomial_taylor_shift

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, P:seq[int]):
  randomize()
  type M = DynamicMatrixType(mint)
  var
    A, B = M.init(N)
    degA, degB = Seq[N: 0]
  for i in N:
    for j in i + 1 ..< N:
      if P[i] < P[j]:
        # i, jはA側にカウントされる
        degA[i].inc
        degA[j].inc
        A[i, j] -= 1
        A[j, i] -= 1
      else:
        degB[i].inc
        degB[j].inc
        B[i, j] -= 1
        B[j, i] -= 1
  for i in N:
    A[i, i] = degA[i]
    B[i, i] = degB[i]
  var A2, B2 = M.init(N - 1)
  for i in 1 ..< N:
    for j in 1 ..< N:
      A2[i - 1, j - 1] = A[i, j]
      B2[i - 1, j - 1] = B[i, j]
  # det(A2 + B2x)を計算したい
  let detB2 = B2.determinant
  if detB2 != 0:
    var invB2 = B2.inv
    A2 *= invB2
    B2 *= invB2
    var p = characteristicPolynomial(-A2)
    for i in p.len:
      p[i] *= detB2
    echo p.join(" ")
  else:
    #var k = mint(random.rand(0 ..< MOD))
    var k = mint(0)
    # x' = x - kに変換を考える
    # det(A2 + B2x) = det(A2 + B2 * k + B2 * x')
    let
      U = A2 + B2 * k
      detU = determinant(U)
    doAssert detU != 0
    var p = characteristic_polynomial(-B2 / U).reversed
    for i in p.len: p[i] *= detU
    var g:FPS[mint] = p
    echo (g.taylor_shift(-k)).join(" ")

    #var x = initVar[mint]()
    #var
    #  g:FPS[mint] = @[mint(1)]
    #  f:FPS[mint] = x - k
    #  s:FPS[mint]
    #s.resize(N)
    #for i in 0 ..< p.len:
    #  s += g * p[i]
    #  g *= f
    #echo s.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  discard

