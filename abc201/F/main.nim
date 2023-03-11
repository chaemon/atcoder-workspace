const DEBUG = true

include atcoder/extra/header/chaemon_header

import atcoder/segtree
import atcoder/extra/dp/cumulative_sum


solveProc solve(N:int, P:seq[int], A:seq[int], B:seq[int], C:seq[int]):
  var st = initSegTree(N,(a, b:int)=>min(a, b), ()=>int.inf)
  var ans = int.inf
  var cs_left, cs_right = initCumulativeSum(N, int)
  for i in 0..<N:
    cs_left[i] = min(0, B[i] - A[i])
    cs_right[i] = min(0, C[i] - A[i])
  for i in 0 .. N:
    ans.min= cs_left[0 ..< i] + cs_right[i .. ^1]
  for i in 0 ..< N:
    var u = min(st[0 ..< P[i]], cs_left[0 ..< P[i]]) - A[P[i]]
    st[P[i]] = u
    ans.min= u + cs_right[P[i] + 1 .. ^1]
  echo ans + A.sum
  discard

# input part {{{
block:
  var N = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, P, A, B, C)
#}}}

