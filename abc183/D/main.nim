include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

import atcoder/extra/dp/dual_cumulative_sum

proc solve(N:int, W:int, S:seq[int], T:seq[int], P:seq[int]) =
  var cs = initDualCumulativeSum[int](2 * 10 ^ 5 + 1)
  for i in 0..<N:
    cs.add(S[i]..<T[i], P[i])
  for i in 0..2*10^5:
    if cs[i] > W:
      echo NO;return
  echo YES
  return


# input part {{{
block:
  var N = nextInt()
  var W = nextInt()
  var S = newSeqWith(N, 0)
  var T = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    S[i] = nextInt()
    T[i] = nextInt()
    P[i] = nextInt()
  solve(N, W, S, T, P)
#}}}
