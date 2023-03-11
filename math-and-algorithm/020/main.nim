const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

#const B = 10
const B = 1000

solveProc solve(N:int, A:seq[int]):
  var dp = Seq[5 + 1, B + 1: 0]
  dp[0][0] = 1
  for a in A:
    var dp2 = dp
    for i in 0 .. 5:
      for j in 0 .. B:
        if i + 1 <= 5 and j + a <= B and dp[i][j] > 0:
          dp2[i + 1][j + a] += dp[i][j]
    swap dp, dp2
  echo dp[5][B]
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

