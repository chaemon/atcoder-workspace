const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/dp/cumulative_sum_2d

const T = 5000

solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  Pred A, B
  var cs = initCumulativeSum2D[int](T, T)
  for i in N:
    cs.add(A[i], B[i], 1)
  cs.build
  ans := -int.inf
  for x in T:
    for y in T:
      let
        x2 = min(T, x + K + 1)
        y2 = min(T, y + K + 1)
      ans.max=cs[x ..< x2, y ..< y2]
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, K, A, B)
