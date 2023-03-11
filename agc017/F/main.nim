include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

proc solve(N:int, M:int, K:int, A:seq[int], B:seq[int], C:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, 0)
  var B = newSeqWith(K, 0)
  var C = newSeqWith(K, 0)
  for i in 0..<K:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, K, A, B, C)
#}}}
