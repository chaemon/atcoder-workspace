when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/math/matrix

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, X:int, Y:int, c:string):
  var ac = Seq[24:mint]
  for i in 24:
    if c[i] == 'T':
      ac[i] = mint(X) / 100
    elif c[i] == 'A':
      ac[i] = mint(Y) / 100
  var p = block: # 1日誰もアクセスしない確率
    p := mint(1)
    for i in 24:
      p *= 1 - ac[i]
    p
  #type MT = DynamicMatrixType(mint)
  type MT = StaticMatrixType(mint)
  var A = MT.init(24)
  for i in 24:
    # iからjへ
    var
      q = mint(1) # i ..< jの間誰もアクセスしない確率
      j = (i + 1) mod 24
    for _ in 24:
      A[j, i] = 1 / (1 - p) * q * ac[j]
      q *= 1 - ac[j]
      j = (j + 1) mod 24
  var b = MT.initVector(24)
  b[^1] = 1
  b = A^N * b
  ans := mint(0)
  for i in 24:
    if c[i] == 'A':
      ans += b[i]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var c = nextString()
  solve(N, X, Y, c)
else:
  discard

