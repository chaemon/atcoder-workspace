when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/extra/other/bitutils

solveProc solve(N:int, M:int, A:seq[seq[int]]):
  var dp = Seq[2^N: int.inf]
  dp[0] = 0
  for i in M:
    var dp2 = dp
    for b in 2^N:
      var b2 = b
      for j in N:
        if A[i][j] == 1:
          b2[j] = 1
      dp2[b2].min=dp[b] + 1
    dp = dp2.move()
  var ans = dp[2^N - 1]
  if ans == int.inf: ans = -1
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, newSeqWith(N, nextInt()))
  solve(N, M, A)
else:
  discard

