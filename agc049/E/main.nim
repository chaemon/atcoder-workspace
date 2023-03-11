include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

proc solve(N:int, C:int, K:int, B:seq[seq[int]]) =
  return

# input part {{{
block:
  var N = nextInt()
  var C = nextInt()
  var K = nextInt()
  var B = newSeqWith(N, newSeqWith(K, nextInt()))
  solve(N, C, K, B)
#}}}
