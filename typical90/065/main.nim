const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination, atcoder/convolution

solveProc solve(R:int, G:int, B:int, K:int, X:int, Y:int, Z:int):
  # 赤r個, 緑g個
  var a, b = K + 1 @ mint(0)
  for r in 0 .. K:
    if K - r > Y: continue
    a[r] = mint.C(R, r)
  for g in 0 .. K:
    if K - g > Z: continue
    b[g] = mint.C(G, g)
  var
    c = a.convolution(b)[0 .. K]
    ans = mint(0)
  for i in 0 .. K:
    if i > X: continue
    ans += c[i] * mint.C(B, K - i)
  echo ans
  return

when not DO_TEST:
  var R = nextInt()
  var G = nextInt()
  var B = nextInt()
  var K = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var Z = nextInt()
  solve(R, G, B, K, X, Y, Z)
