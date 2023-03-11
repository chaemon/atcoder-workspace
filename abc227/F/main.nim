const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(H:int, W:int, K:int, A:seq[seq[int]]):
  var ans = int.inf
  proc calc(M:int):int =
    var dp = Seq[H + 1, W:int.inf]
    dp[0][0] = 0
    proc set_dp() =
      # set dp
      for i in H:
        for j in W:
          if dp[i][j] == int.inf: continue
          if A[i][j] <= M:
            if i + 1 < H:
              dp[i + 1][j].min= dp[i][j]
            if j + 1 < W:
              dp[i][j + 1].min= dp[i][j]
      if A[H - 1][W - 1] <= M:
        dp[H][0].min=dp[H - 1][W - 1]
    for k in K:
      set_dp()
      var dp2 = Seq[H + 1, W:int.inf]
      for i in H:
        for j in W:
          if A[i][j] >= M:
            if i + 1 < H:
              dp2[i + 1][j].min=dp[i][j] + A[i][j]
            if j + 1 < W:
              dp2[i][j + 1].min=dp[i][j] + A[i][j]
      if A[H - 1][W - 1] >= M:
        dp2[H][0].min=dp[H - 1][W - 1] + A[H - 1][W - 1]
      swap dp, dp2
    set_dp()
    return dp[H][0]

  for i in H:
    for j in W:
      let c = calc(A[i][j])
      ans.min=c
  echo ans
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var K = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, K, A)
else:
  discard

