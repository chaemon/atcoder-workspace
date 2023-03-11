when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination
import atcoder/convolution

solveProc solve(N: int, A: int):
  if N == 1:
    echo mint(A);return
  var f:seq[mint]
  var p = mint(1)
  for i in N + 1:
    # p = C(A, i)
    f.add p
    p *= A - i
    p *= mint.inv(i + 1)
  proc calc(l, r: int, tmp:seq[mint]): seq[mint] =
    doAssert l < r
    let d = r - l
    # l ..< rについて
    # result = (1 + x * a[l]) * (1 + x * a[l + 1]) * ... * (1 + x * a[r - 1])
    # tmp = f(x) * (1 + x * a[1]) * (1 + x * a[2]) * ... * (1 + x * a[l - 1])
    # tmpはl ..< rを決定するのに必要な部分しか持たない
    # tmpはl - 2からある
    # tmpの長さはdにする
    if d == 1:
      let a = tmp[0] # これが計算できないといけない
      if l == N:
        echo a
        doAssert a.val mod 4 == 0
      return @[mint(1), a]
    var tmp = tmp
    let m = (l + r) shr 1
    var L = calc(l, m, tmp[0 ..< m - l])
    tmp = convolution(tmp, L)
    var R = calc(m, r, tmp[m - l .. ^1])
    return convolution(L, R)
  discard calc(2, N + 1, f[2 .. ^1])

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  solve(N, A)
else:
  discard

