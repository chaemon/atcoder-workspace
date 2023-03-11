include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc solve(A:int, B:int, C:int) =
  var ans = mint(1)
  ans *= A * (A + 1) div 2
  ans *= B * (B + 1) div 2
  ans *= C * (C + 1) div 2
  echo ans
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}
