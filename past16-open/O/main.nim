when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/matrix

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

# Failed to predict input format
solveProc solve():
  type MT = DynamicMatrixType(mint)
  let N, K, Q = nextInt()
  var
    a = Seq[N + 1: MT.initVector(K)]
    A = Seq[N: nextInt()]
    P = Seq[K: mint(nextInt())]
  var
    p: seq[MT]
    M = MT.init(K, K)
  for i in K - 1:
    M[i, i + 1] = 1
  for i in K:
    M[K - 1, i] = P[K - 1 - i]
  var M0 = MT.unit(K)
  for i in N + 1:
    p.add M0
    M0 *= M
  # x_{n+1} = M * x_n
  for _ in Q:
    var l, r = nextInt()
    l.dec
    # l ..< r
    var b = MT.initVector(Seq[K: nextInt()])
    a[l] += b
    a[r] -= p[r - l] * b
  var
    v = MT.initVector(K)
    ans = Seq[N: mint(0)]
  for i in N:
    v += a[i]
    ans[i] = A[i] + v[0]
    v = M * v
  echo ans.join(" ")
  doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

