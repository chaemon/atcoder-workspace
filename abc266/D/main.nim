const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, T:seq[int], X:seq[int], A:seq[int]):
  var dp = Array[5: -int.inf]
  dp[0] = 0
  var j = 0
  for t in 1 .. 10^5:
    dp2 := Array[5: -int.inf]
    for p in 5:
      dp2[p].max=dp[p]
      if p - 1 >= 0: dp2[p].max=dp[p - 1]
      if p + 1 < 5: dp2[p].max=dp[p + 1]
    if j < N and T[j] == t:
      dp2[X[j]] += A[j]
      j.inc
    swap dp, dp2
  echo dp.max
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    X[i] = nextInt()
    A[i] = nextInt()
  solve(N, T, X, A)
else:
  discard

