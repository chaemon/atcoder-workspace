when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import  lib/dp/cumulative_sum_2d

solveProc solve(H:int, W:int, X:seq[seq[int]], Q:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  Pred A, B
  var cs = initCumulativeSum2D[int](H, W)
  for i in H:
    for j in W:
      cs.add(i, j, X[i][j])
  cs.build
  for q in Q:
    echo cs[A[q] ..< C[q], B[q] ..< D[q]]
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var X = newSeqWith(H, newSeqWith(W, nextInt()))
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  var C = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(H, W, X, Q, A, B, C, D)
else:
  discard

