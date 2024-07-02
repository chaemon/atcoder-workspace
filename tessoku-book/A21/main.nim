when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int], A:seq[int]):
  Pred P
  var dp = Seq[N, N + 1: 0]
  for d in 2 .. N:
    for i in N:
      let j = i + d
      if j > N: break
      # i ..< j
      let x = if P[i] in i ..< j: A[i] else: 0
      dp[i][j].max=dp[i + 1][j] + x
      let y = if P[j - 1] in i ..< j: A[j - 1] else: 0
      dp[i][j].max=dp[i][j - 1] + y
  echo dp[0][N]

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
    A[i] = nextInt()
  solve(N, P, A)
else:
  discard

