include atcoder/extra/header/chaemon_header

import atcoder/math

proc solve(N:int, M:int) =
  var r = powMod(10, N, M * M)
  echo r div M
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
#}}}
