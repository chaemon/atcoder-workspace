const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  var dp = [true, true]
  for i in 1 ..< N:
    var dp2 = [false, false]
    if dp[0]:
      if abs(A[i - 1] - A[i]) <= K:
        dp2[0] = true
      if abs(A[i - 1] - B[i]) <= K:
        dp2[1] = true
    if dp[1]:
      if abs(B[i - 1] - A[i]) <= K:
        dp2[0] = true
      if abs(B[i - 1] - B[i]) <= K:
        dp2[1] = true
    swap dp, dp2
  if dp[0] or dp[1]:
    echo YES
  else:
    echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, K, A, B)
else:
  discard

