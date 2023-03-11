const DO_CHECK = true
include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const DEBUG = true

proc solve(N:int, P:int) =
  echo mint(P - 1) * mint(P - 2)^(N - 1)
  var a = @[3, 1, 4]
  return

# input part {{{
block:
  var N = nextInt()
  var P = nextInt()
  solve(N, P)
#}}}
