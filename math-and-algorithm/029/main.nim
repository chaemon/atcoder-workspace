const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  var dp = Seq[60: -1]
  proc calc(n:int):int =
    if dp[n] >= 0: return dp[n]
    if n <= 1:
      result = 1
    else:
      result = calc(n - 1) + calc(n - 2)
    dp[n] = result
  echo calc(N)

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

