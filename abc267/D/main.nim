const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int]):
  var dp = Seq[M + 1: -int.inf]
  dp[0] = 0
  for i in N:
    var dp2 = dp
    for k in 0 ..< M:
      dp2[k + 1].max=dp[k] + (k + 1) * A[i]
    dp = dp2.move
  echo dp[M]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

