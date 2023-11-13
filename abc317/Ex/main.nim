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
#import lib/math/formal_power_series_rational
import lib/other/operator
import lib/math/matrix

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const
  z:FPS[mint] = @[mint(0)]
  u:FPS[mint] = @[mint(1)]
  p = getDefaultOperator(FPS[mint], z, u)

solveProc solve(N:int, K:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  type M = StaticMatrixType(FPS[mint], p)
  let zz = M.init(3, 3)
  var q = newSeq[zz.type]()
  var
    zero:FPS[mint] = @[mint(0)]
    one:FPS[mint] = @[mint(1)]
    x:FPS[mint] = @[mint(0), mint(1)]
    #c:FPS[mint] = @[mint(1)] // @[mint(1), mint(-1)] # 1 / (1 - x)
    d:FPS[mint] = @[mint(1), mint(-1)] # 1 - x
  for n in 1 ..< N << 1:
    # デフォルトで1 - xをかける
    var
      X = zz
      a:FPS[mint] = if n - 1 >= 0 and B[n - 1] == 1: x else: zero
      b:FPS[mint] = if n - 2 >= 0 and C[n - 2] == 1: x else: zero
    #if A[n] == 1:
    #  a *= c
    #  b *= c
    if A[n] == 0:
      a *= d
      b *= d
    X[0,0] = a
    X[0,1] = b

    #X[1,0] = one  # x
    X[1,0] = d

    if D[n] == 1:
      X[2,0] = a
      X[2,1] = b
    #X[2,2] = one
    X[2,2] = d
    q.add X
  proc calc(l, r:int):auto =
    if r - l == 1:
      return q[l]
    else:
      let m = (l + r) div 2
      return calc(l, m) * calc(m, r)
  let X = calc(0, q.len)
  var v = M.initVector(3)
  v[0] = one
  v[2] = zero
  v = X * v
  for i in 3:
    v[i].resize(K + 1)
  let t = v[2] * x
  var d0 = d.pow(N - 1, N)
  d0.resize(K + 1)
  var F = t / d0
  if D[0] == 1:
    F[1] += 1
  let u = (1 / (1 - F)) * (v[0] / d0)
  echo u[K]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  var D = newSeqWith(N, nextInt())
  solve(N, K, A, B, C, D)
else:
  discard

