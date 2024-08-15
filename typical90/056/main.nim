const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const NO = "Impossible"

solveProc solve(N:int, S:int, A:seq[int], B:seq[int]):
  var dp = Seq[N + 1, S + 1: int8(-1)]
  dp[0][0] = 0
  for i in N:
    for s in 0 .. S:
      if dp[i][s] != -1 and s + A[i] <= S:
        dp[i + 1][s + A[i]] = 0
      if dp[i][s] != -1 and s + B[i] <= S:
        dp[i + 1][s + B[i]] = 1
  if dp[N][S] == -1:
    echo NO;return
  var
    s = S
    ans = ""
  for i in 0 ..< N << 1:
    if dp[i + 1][s] == 0:
      ans.add 'A'
      s -= A[i]
    elif dp[i + 1][s] == 1:
      ans.add 'B'
      s -= B[i]
    else:
      doAssert false
  ans.reverse
  echo ans
  doAssert false
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, S, A, B)
#}}}

