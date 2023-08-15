when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/ntt
import lib/math/formal_power_series

import atcoder/modint
type mint = modint998244353

import atcoder/convolution
import lib/math/combination

solveProc solve(A:int, B:int, C:int, T:int):
  proc calc(a, b, c:int):FormalPowerSeries[mint] =
    doAssert a <= b and b <= c
    block:
      let r = a mod 2
      assert b mod 2 == r and c mod 2 == r
    # a, b, cにいる三人が
    # xに動く場合(x mod 2 == a mod 2)
    # a - Tの位置を0として, a + Tまで考える
    # つまりa - T, a - T + 2, a - T + 4, a - T + 6, ..., a + Tのインデックスがそれぞれ
    # 0, 1, 2, ..., Tとなる
    let
      da = 0
      db = (b - a) div 2
      dc = (c - a) div 2
    var 
      v, w = Seq[mint]
    for i in 0 .. T:
      p := mint(1)
      for d in [da, db, dc]:
        if i - d in 0 .. T:
          p *= mint.rfact(i - d)
        else:
          p = 0
      v.add p
      p = 1
      for d in [da, db, dc]:
        if i + d in 0 .. T:
          p *= mint.rfact(i + d)
        else:
          p = 0
      w.add p
    var u = (v.convolution(w))[0 .. T]
    for t in 0 .. T:
      u[t] *= (mint.fact(t)/mint(2)^t)^3
    return u
  var (A, B, C) = (A, B, C)
  var v = [A, B, C].sorted
  A = v[0]
  B = v[1]
  C = v[2]
  var
    x = initFormalPowerSeries(calc(A, B, C))
    y = initFormalPowerSeries(calc(0, 0, 0))
  echo (x / y)[T]
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var T = nextInt()
  solve(A, B, C, T)
else:
  discard

