include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/math/combination

proc solve(d:int) =
  echo mint.C(d * 2, d) / 2
  return

# input part {{{
block:
  var d = nextInt()
  solve(d)
#}}}
