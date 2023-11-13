when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:int, X:seq[int], P:seq[int], F:seq[int]):
  var dp = Seq[H + 1, H + 1: int.inf] # dp[i][j]: 往路iリットル, 復路jリットル持っている状態にするための所持金の最小値
  for j in 0 .. H:
    dp[H][j] = 0
  for i in N:
    let d = if i == 0: X[0] else: X[i] - X[i - 1]
    # X[i - 1] -> X[i]の推移を考える
    block:
      var dp2 = Seq[H + 1, H + 1: int.inf]
      # X[i]にあるガソリンスタンドを用いない場合
      for k in H + 1:
        let k2 = k - d
        if k2 < 0: continue
        for l in H + 1:
          # k, lからd動く
          let l2 = l + d
          if l2 > H: continue
          dp2[k2][l2].min=dp[k][l]
      # X[i - 1]からX[i]に移った
      dp = dp2.move
    if i < N - 1:
      var dp2 = dp
      # 移った先でガソリンスタンドを使うか
      # X[i]にあるガソリンスタンドを往路で用いる場合
      for k in H + 1:
        let k2 = min(H, k + F[i])
        for l in H + 1:
          dp2[k2][l].min=dp[k][l] + P[i]
      # X[i]にあるガソリンスタンドを復路で用いる場合
      for k in H + 1:
        for l2 in H + 1:
          # l2 -> l = min(H, l2 + F[i])
          let l = min(H, l2 + F[i])
          dp2[k][l2].min=dp[k][l] + P[i]
      dp = dp2.move
  var ans = int.inf
  for k in H + 1:
    ans.min=dp[k][k]
  if ans == int.inf:
    echo -1
  else:
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = nextInt()
  var X = newSeqWith(N, nextInt())
  var P = newSeqWith(N-1, 0)
  var F = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    P[i] = nextInt()
    F[i] = nextInt()
  solve(N, H, X, P, F)
else:
  discard

