when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int]):
  var dp:seq[float] = @[0.0] # dp[i]: i個参加したときのΣ(0.9)^(k - i) Q_iの最大値
  for i in N:
    var dp2 = dp & 0.0
    for j in dp.len:
      dp2[j + 1].max=dp[j] * 0.9 + float(P[i])
    dp = dp2.move
  var
    ans = - inf(float)
    s = 0.0
  for k in 1 ..< dp.len:
    s *= 0.9
    s += 1.0
    ans.max=dp[k] / s - 1200.0 / sqrt(float(k))
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  discard

