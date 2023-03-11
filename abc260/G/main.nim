const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum_2d

solveProc solve(N:int, M:int, S:seq[string], Q:int, X:seq[int], Y:seq[int]):
  var
    cs0 = initDualCumulativeSum2D[int](N, N) # (i, j)
    cs1 = initDualCumulativeSum2D[int](N * 3, N) # (2 * i + j, i)
    cs2 = initDualCumulativeSum2D[int](N * 3, N) # (2 * i + j, j)
    ct = 0
  for s in N:
    for t in N:
      if S[s][t] == 'O':
        cs0.add(0 ..< N, 0 ..< N, 1)
        #let M0 = min(N * 3, 2 * s + t + 2 * M)
        let M0 = 2 * s + t + 2 * M
        cs2.add(0 ..< M0, 0 ..< t, -1)
        # (u - s) + (v - t) / 2 >= M and s <= u
        cs1.add(M0 ..< N * 3, s ..< N, -1)
        # u < s and v >= t
        cs0.add(0 ..< s, t ..< N, -1)
  cs0.build
  cs1.build
  cs2.build
  for q in Q:
    let (X, Y) = (X[q], Y[q])
    echo cs0[X, Y] + cs1[X * 2 + Y, X] + cs2[X * 2 + Y, Y]
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  var Q = nextInt()
  var X = newSeqWith(Q, 0)
  var Y = newSeqWith(Q, 0)
  for i in Q:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, S, Q, X.pred, Y.pred)
else:
  discard

