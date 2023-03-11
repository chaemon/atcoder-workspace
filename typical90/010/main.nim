const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/dp/cumulative_sum

solveProc solve(N:int, C:seq[int], P:seq[int], Q:int, L:seq[int], R:seq[int]):
  var cs1, cs2 = initCumulativeSum(N, int)
  for i in 0..<N:
    if C[i] == 1:
      cs1[i] = P[i]
    else:
      cs2[i] = P[i]
  for i in 0..<Q:
    echo cs1[L[i]..<R[i]], " ", cs2[L[i]..<R[i]]
  return


# input part {{{
when not DO_TEST:
  var N = nextInt()
  var C = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    C[i] = nextInt()
    P[i] = nextInt()
  var Q = nextInt()
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt() - 1
    R[i] = nextInt()
  solve(N, C, P, Q, L, R)
#}}}

