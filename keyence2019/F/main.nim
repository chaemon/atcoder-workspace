include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import atcoder/extra/math/combination

proc solve(H:int, W:int, K:int) =
  var ans = mint(0)
  for s in 1..K:
    var d = mint(0)
    d += mint.C(H + W, s)
    d += mint.C(H + W - 1, s - 1) * (H + W)
    d += mint.C(H + W - 2, s - 2) * H * W
    d *= mint.fact(s)
    d *= mint.P(H + W - s, K - s)
    ans += d
  echo ans
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var K = nextInt()
  solve(H, W, K)
#}}}
