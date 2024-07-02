when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var
    dp = Seq[N: int.inf]
    prev = Seq[N: -1]
  dp[0] = 0
  for i in N - 1:
    if dp[i] + A[i] < dp[i + 1]:
      dp[i + 1] = dp[i] + A[i]
      prev[i + 1] = i
    if i + 2 < N and dp[i] + B[i] < dp[i + 2]:
      dp[i + 2] = dp[i] + B[i]
      prev[i + 2] = i
  var ans:seq[int]
  var i = N - 1
  while true:
    ans.add i + 1
    if i == 0: break
    i = prev[i]
  ans.reverse
  echo ans.len
  echo ans.join(" )

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-2+1, nextInt())
  var B = newSeqWith(N-3+1, nextInt())
  solve(N, A, B)
else:
  discard

