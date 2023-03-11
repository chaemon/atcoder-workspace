const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:int, A:seq[int]):
  var dp = Seq[S + 1: false]
  dp[0] = true
  for i in N:
    var dp2 = dp
    for j in 0 .. S:
      if not dp[j]: continue
      if j + A[i] <= S:
        dp2[j + A[i]] = true
    swap dp, dp2
  if dp[S]: echo YES
  else: echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, S, A)
else:
  discard

