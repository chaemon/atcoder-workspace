when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int]):
  var dp = Seq[M + 1, 2: -int.inf]
  dp[0][0] = 0
  for d in N:
    var dp2 = Seq[M + 1, 2: -int.inf]
    # d日目に宿題をする
    for k in 0 .. M - 1:
      dp2[k + 1][1].max=dp[k][0]
    # d日目に遊ぶ
    for k in 0 .. M:
      dp2[k][0].max=dp[k][0] + A[d]
      dp2[k][0].max=dp[k][1] + A[d]
    dp = dp2.move
  echo max(dp[M][0], dp[M][1])

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

