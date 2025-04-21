when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var dp = [0, -int.inf]
  for i in N:
    var dp2 = dp
    if dp[0] >= 0:
      dp2[1].max=dp[0] + A[i]
    if dp[1] >= 0:
      dp2[0].max=dp[1] + A[i] * 2
    dp = dp2.move
  echo dp.max
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

