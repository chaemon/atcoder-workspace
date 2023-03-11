include atcoder/extra/header/chaemon_header
import atcoder/extra/math/combination

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

proc solve(N:int, M:int, A:seq[int]) =
  let S = A.sum
  var ans = mint.C_large(M + N, N + S)
#  var ans = mint.C_large(-(S + N + 1), M - S)
#  if (M - S) mod 2 != 0: ans *= -1
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
#}}}
