when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

const DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
type mint = modint

import random

solveProc solve(n, p:int):
  mint.setMod(p)
  var x, y, z, L, R:mint
  while true:
    var x0, y0, z0 = random.rand(1 .. p - 1)
    if x0 == y0 or y0 == z0 or z0 == x0: continue
    x = mint(x0)
    y = mint(y0)
    z = mint(z0)
    L = (x + y + z) * (x^n + y^n + z^n) * (x^(2*n) + y^(2*n) + z^(2*n))
    R = x^(3*n) + y^(3*n) + z^(3*n)
    if L == 0 or R == 0: continue
    break
  let alpha = R / L
  x *= alpha
  y *= alpha
  z *= alpha
  var v = [x.val, y.val, z.val].sorted
  x = v[0]
  y = v[1]
  z = v[2]
  echo x, " ", y, " ", z
  Check(strm):
    let
      x0 = strm.nextInt()
      y0 = strm.nextInt()
      z0 = strm.nextInt()
    doAssert x0 in 1 .. p - 1
    doAssert y0 in 1 .. p - 1
    doAssert z0 in 1 .. p - 1
    doAssert x0 < y0 and y0 < z0
    let
      x = mint(x0)
      y = mint(y0)
      z = mint(z0)
      L = (x + y + z) * (x^n + y^n + z^n) * (x^(2*n) + y^(2*n) + z^(2*n))
      R = x^(3*n) + y^(3*n) + z^(3*n)
    doAssert L == R
  discard

when not DO_TEST:
  for _ in nextInt():
    let n, p = nextInt()
    solve(n, p)
else:
  for p in [5, 7, 11, 13, 17, 19, 23, 29, 998244353]:
    for n in 1 .. 1000:
      test(n, p)
  discard

