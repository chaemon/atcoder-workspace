const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(R:int, G:int, B:int, K:int):
  proc calc(k:int):mint = # RGをk個持つ
    if k > R or k > G: return 0
    R := R - k
    G := G - k
    return mint.fact(R + G + B + k) * mint.rfact(R) * mint.rfact(G) * mint.rfact(B) * mint.rfact(k)
  ans := mint(0)
  for t in K .. max(R, G):
    if (t - K) mod 2 == 0:
      ans += calc(t) * mint.C(t, K)
    else:
      ans -= calc(t) * mint.C(t, K)
  echo ans
  discard

when not defined(DO_TEST):
  var R = nextInt()
  var G = nextInt()
  var B = nextInt()
  var K = nextInt()
  solve(R, G, B, K)
else:
  discard

