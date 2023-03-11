const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, X:int, a:seq[int], b:seq[int]):
  var dp = Seq[X + 1: false]
  dp[0] = true
  for i in N:
    var dp2 = Seq[X + 1: false]
    for j in 0..X:
      if not dp[j]: continue
      if j + a[i] <= X: dp2[j + a[i]] = true
      if j + b[i] <= X: dp2[j + b[i]] = true
    swap dp, dp2
  if dp[X]: echo YES
  else: echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, X, a, b)
else:
  discard

