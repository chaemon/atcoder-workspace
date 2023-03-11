include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc solve(g:seq[int], r:seq[int]) =
  return

# input part {{{
block:
  var g = newSeqWith(3, 0)
  var r = newSeqWith(3, 0)
  for i in 0..<3:
    g[i] = nextInt()
    r[i] = nextInt()
  solve(g, r)
#}}}
