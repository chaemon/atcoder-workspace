const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/matrix
import lib/math/ntt
import lib/math/formal_power_series
import lib/math/coef_of_generating_function
import random


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  type MT = MatrixType(mint)
  A0 := MT.init(N)
  b := MT.initVector(N)
  for i in N:
    let x = mint(random.rand(0..<MOD))
    b[i] = 1
    for j in N:
      var t = mint(1 - A[j] * x)
      A0[i][j] = 1 / t
      b[i] *= t
    b[i] = 1 / b[i]
  b = A0.inv * b
  var x = initVar[mint]()
  var P = 0 * x + mint(1)
  for i in 0..<N:
    P *= 1 - mint(A[i])^(B[i] + 1) * x ^ (B[i] + 1)
  ans := mint(0)
  for (d, c) in P:
    if d > M: continue
    for j in N:
      ans += b[j] * c * mint(A[j])^(M - d)
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

