when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, S:int, A:seq[int]):
  var dp = Seq[S + 1: false]
  dp[0] = true
  for i in N:
    var dp2 = dp
    for s in 0 .. S:
      if not dp[s]: continue
      if s + A[i] <= S:
        dp2[s + A[i]] = true
    dp = dp2.move
  if dp[S]: echo YES
  else: echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, S, A)
else:
  discard

