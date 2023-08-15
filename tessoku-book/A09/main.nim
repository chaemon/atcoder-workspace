when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum_2d

solveProc solve(H:int, W:int, N:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  Pred A, B
  var cs = initDualCumulativeSum2D[int](H, W)
  for i in N:
    cs.add(A[i] ..< C[i], B[i] ..< D[i], 1)
  cs.build
  var ans = Seq[H, W:0]
  for i in H:
    for j in W:
      ans[i][j] = cs[i, j]
  for i in H:
    echo ans[i].join(" ")
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(H, W, N, A, B, C, D)
else:
  discard

