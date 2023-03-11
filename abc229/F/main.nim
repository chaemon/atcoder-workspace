const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var ans = int.inf
  # X, Yのパートに分ける
  # 頂点0はXに含める
  for t in 0..1:
    # t = 0: 頂点1がX, t = 1: 頂点1がY
    var dp = Array[2, 2: int.inf] # 直前(X:0, Y:1), Yが現れたかどうか
    if t == 0:
      dp[0][0] = A[0]
    else:
      dp[1][1] = 0
    for i in 0..<N-1:
      var dp2 = Array[2, 2: int.inf]
      for c in 0..1:
        for u in 0..1:
          for c2 in 0..1:
            var v = dp[c][u]
            if v == int.inf: continue
            var u2 = u
            if c2 == 0: v += A[i + 1]
            if c == c2: v += B[i]
            if c2 == 1: u2 = 1
            dp2[c2][u2].min=v
      swap dp, dp2
    for c in 0..1:
      var v = dp[c][1]
      if c == t: v += B[^1]
      ans.min=v
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
else:
  discard

