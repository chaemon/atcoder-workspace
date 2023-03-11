include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

proc solve(N:int) =
  var
    b = 0
    ans = int.inf
  while true:
    let B = 2^b
    let c = N mod B
    let a = N div B
    ans.min= a + b + c
    if B > N: break
    b.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

