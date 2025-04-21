when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/extra/math/floor_sum_square

solveProc solve(N:int, M:int, A:int, B:seq[int]):
  var
    ans = 0
    B = B
  if B[0] > B[1]: swap B[0], B[1]
  if A == 0: echo N * B[0] * B[1];return
  ans += A^2 * (N - 1) * N * (2 * N - 1) div 6 + A * (B[0] + B[1]) * (N - 1) * N div 2 + N * B[0] * B[1]
  block:
    let (S1, _, S3) = floor_sum_square(N, M, A, B[1])
    ans -= M * (A * S1 + B[0] * S3)
  block:
    let (S1, _, S3) = floor_sum_square(N, M, A, B[0])
    ans -= M * (A * S1 + B[1] * S3)

  block:
    var
      u = floor_sum_square(N, M, A, B[1]).S2
      v = 0
    let X = floorDiv(A * (N - 1) + B[1], M)
    block:
      let (S1, _, _) = floor_sum_square(X, -A, M, -B[0])
      v += S1
    block:
      let (S1, _, _) = floor_sum_square(X, -A, M, -B[1])
      v -= S1
    v -= X * min(N, ceilDiv(X * M - B[0], A))
    v += X * min(N, ceilDiv(X * M - B[1], A))
    ans += M^2 * (u + v)
  echo ans

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var M = nextInt()
    var A = nextInt()
    var B = newSeqWith(2, nextInt())
    solve(N, M, A, B)
else:
  discard

