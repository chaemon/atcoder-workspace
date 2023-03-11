const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(H:int, W:int, C:int, A:seq[seq[int]]):
  var
    A = A
    ans = int.∞
  for _ in 2:
    var
      dp = Seq[H, W: int.inf]
    for i in H:
      for j in W:
        if i > 0: dp[i][j].min=dp[i - 1][j] + C
        if j > 0: dp[i][j].min=dp[i][j - 1] + C
        if dp[i][j] < int.∞:
          ans.min=dp[i][j] + A[i][j]
        dp[i][j].min=A[i][j]
    for i in H:
      for j in W:
        let j2 = W - 1 - j
        if j > j2: break
        swap A[i][j], A[i][j2]
  echo ans
  Naive:
    var ans = int.∞
    for i in H:
      for j in W:
        for i2 in H:
          for j2 in W:
            if (i, j) == (i2, j2): continue
            ans.min= C * (abs(i - i2) + abs(j - j2)) + A[i][j] + A[i2][j2]
    echo ans
  return

# input part {{{
when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var C = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, C, A)
else:
  import random
  let
    H = 10
    W = 13
  for ct in 100:
    var
      C = random.rand(1..9)
      A = Seq[H, W:int]
    for i in H:
      for j in W:
        A[i][j] = random.rand(1..9)
    test(H, W, C, A)
#}}}

