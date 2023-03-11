const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/other/bitutils

solveProc solve(N:int, D:int, A:seq[int]):
  var dp = Seq[2^N: 0]
  dp[0] = 1
  for d in D:
    var dp2 = dp
    for b in 2^N:
      if dp[b] == 0: continue
      # d桁目を1にする
      b2 := b
      for j in N:
        if A[j][d] == 1:
          b2[j] = 1
      dp2[b2] += dp[b]
    dp = dp2.move
  echo dp[2^N - 1]
  return

when not DO_TEST:
  var N = nextInt()
  var D = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, D, A)
