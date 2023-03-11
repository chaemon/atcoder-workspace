include atcoder/extra/header/chaemon_header

import atcoder/extra/other/binary_search
import atcoder/extra/dp/cumulative_sum_2d

const DEBUG = true

proc solve(N:int, K:int, A:seq[seq[int]]) =
  let v = (K^2 + 1) div 2
  proc f(d:int):bool =
    var cs = initCumulativeSum2D[int](N, N)
    for i in 0..<N:
      for j in 0..<N:
        if A[i][j] <= d:
          cs.add(i, j, 1)
    cs.build()
    for i in N - K + 1:
      for j in N - K + 1:
        if cs[i..<i+K, j..<j+K] >= v: return true
    return false
  echo f.minLeft(0 .. 2 * 10^9)
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, K, A)
#}}}

