when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, A:seq[int]):
  var dp = Seq[N, N, N + 1: mint(0)]
  for k in N:
    for j in 0 ..< k:
      for i in 0 ..< j:
        # i, j, k
        if A[k] - A[j] == A[j] - A[i]:
          for l in 2 ..< N:
            dp[j][k][l + 1] += dp[i][j][l]
    for j in 0 ..< k:
      dp[j][k][2].inc
  var ans = Seq[N + 1: mint(0)]
  ans[1] = N
  for l in 2 .. N:
    for j in N:
      for i in 0 ..< j:
        ans[l] += dp[i][j][l]
  echo ans[1 .. ^1].join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

