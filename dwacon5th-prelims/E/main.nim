include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc solve() =
  let N = nextInt()
  var a = Seq(N, nextInt())
  a.sort()
  var ans = mint(1)
  for i in 0..<N:
    ans *= gcd(i, a[i])
  echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
