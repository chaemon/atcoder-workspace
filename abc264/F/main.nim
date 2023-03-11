const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header



solveProc solve(H:int, W:int, R:seq[int], C:seq[int], A:seq[string]):
  var dp = Seq[H, W, 2, 2: int.inf]
  dp[0][0][0][0] = 0
  dp[0][0][1][0] = R[0]
  dp[0][0][0][1] = C[0]
  dp[0][0][1][1] = R[0] + C[0]
  for i in H:
    for j in W:
      for br in 0 .. 1:
        for bc in 0 .. 1:
          if i + 1 < H:
            # (i + 1, j)に行く
            var br2:int
            if A[i][j] == A[i + 1][j]: br2 = br
            else: br2 = 1 - br
            if br2 == 1: dp[i + 1][j][br2][bc].min=dp[i][j][br][bc] + R[i + 1]
            else: dp[i + 1][j][br2][bc].min=dp[i][j][br][bc]
          if j + 1 < W:
            # (i, j + 1)に行く
            var bc2:int
            if A[i][j] == A[i][j + 1]: bc2 = bc
            else: bc2 = 1 - bc
            if bc2 == 1: dp[i][j + 1][br][bc2].min=dp[i][j][br][bc] + C[j + 1]
            else: dp[i][j + 1][br][bc2].min=dp[i][j][br][bc]
  ans := int.inf
  for i in 0..1:
    for j in 0..1:
      ans.min=dp[H - 1][W - 1][i][j]
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var R = newSeqWith(H, nextInt())
  var C = newSeqWith(W, nextInt())
  var A = newSeqWith(H, nextString())
  solve(H, W, R, C, A)
else:
  discard

