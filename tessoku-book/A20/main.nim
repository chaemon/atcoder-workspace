when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, T:string):
  var dp = Seq[S.len + 1, T.len + 1: -int.inf]
  dp[0][0] = 0
  for i in S.len + 1:
    for j in T.len + 1:
      if i == 0 and j == 0: dp[i][j] = 0
      else:
        if i - 1 >= 0: dp[i][j].max= dp[i - 1][j]
        if j - 1 >= 0: dp[i][j].max= dp[i][j - 1]
        if i - 1 >= 0 and j - 1 >= 0 and S[i - 1] == T[j - 1]:
          dp[i][j].max= dp[i - 1][j - 1] + 1
  echo dp[S.len][T.len]
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

