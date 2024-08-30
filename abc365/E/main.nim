when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

import lib/other/bitutils

solveProc solve(N:int, A:seq[int]):
  proc calc(a:seq[int]):int =
    # a[i .. j] = 1となるものの個数
    result = 0
    var dp = Array[2: 0]
    for i in N:
      if a[i] == 1:
        swap dp[0], dp[1]
      # a[i]で始める
      dp[a[i]].inc
      # a[i]で終える
      result += dp[1]
  ans := 0
  for d in 27:
    var a:seq[int]
    for i in N:
      if A[i][d] == 1: a.add 1
      else: a.add 0
    let u = calc(a)
    ans += (1 << d) * u
  ans -= A.sum
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

