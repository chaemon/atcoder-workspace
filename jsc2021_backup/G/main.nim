include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const DEBUG = true

proc solve(N:int, A:seq[seq[int]]) =
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, A)
#}}}

