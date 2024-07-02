when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:int, B:int):
  var dp = Seq[N + 1: false]
  for i in 1 .. N:
    if i >= A and not dp[i - A]:
      dp[i] = true
    if i >= B and not dp[i - B]:
      dp[i] = true
  echo if dp[N]: "First" else: "Second"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, A, B)
else:
  discard

