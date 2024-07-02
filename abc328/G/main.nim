when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, C:int, A:seq[int], B:seq[int]):
  var dp = Seq[2^N: int.inf]
  dp[0] = -C
  for b in 2^N:
    let p = b.popCount()
    for i in N:
      var s = C
      var b0 = b
      for t in N:
        if i + t >= N or p + t >= N or b[i + t] == 1: break
        b0[i + t] = 1
        s += abs(A[i + t] - B[p + t])
        # Aのi .. i + tをBのp .. p + tにマッチング
        dp[b0].min=dp[b] + s
  echo dp[2^N - 1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var C = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, C, A, B)
else:
  discard

