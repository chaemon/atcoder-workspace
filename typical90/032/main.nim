const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/other/bitutils

solveProc solve(N:int, A:seq[seq[int]], M:int, X:seq[int], Y:seq[int]):
  Pred X, Y
  var dp = Seq[2^N, N: int.inf]
  # 区間0
  for i in N:
    dp[1 shl i][i] = A[i][0]
  var x = Seq[N, N: false]
  for i in M:
    x[X[i]][Y[i]] = true
    x[Y[i]][X[i]] = true
  for c in N - 1:
    # 区間iから区間i + 1
    var dp2 = Seq[2^N, N: int.inf]
    for b in 2^N:
      for i in N:
        if b[i] == 0 or dp[b][i] == int.inf: continue
        for j in N:
          if b[j] == 1 or x[i][j]: continue
          let b2 = b or (1 shl j)
          dp2[b2][j].min= A[j][c + 1] + dp[b][i]
    dp = dp2.move
  var ans = int.inf
  for i in N:
    ans.min=dp[(2^N) - 1][i]
  echo if ans == int.inf: -1 else: ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, A, M, X, Y)
