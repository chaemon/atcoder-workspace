when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(S:string, K:int):
  let N = S.len
  var dp = Seq[N + 1, N + 1: Option[int]]
  proc calc(i, j:int):int =
    if dp[i][j].isSome: return dp[i][j].get
    result = j - i
    if i < j:
      # i ..< j
      if S[i] == 'o':
        for k in i + 1 ..< j:
          if S[k] == 'f' and calc(i + 1, k) == 0:
            result.min=max(calc(k + 1, j) - K, 0)
      for k in i + 1 ..< j:
        if S[k] == 'o':
          result.min=calc(i, k) + calc(k, j)
    dp[i][j] = result.some
  echo calc(0, N)
  discard

when not defined(DO_TEST):
  var S = nextString()
  var K = nextInt()
  solve(S, K)
else:
  discard

