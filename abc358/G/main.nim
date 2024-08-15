when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, K:int, S_i:int, S_j:int, A:seq[seq[int]]):
  Pred S_i, S_j
  var a = Seq[H, W: -int.inf]
  a[S_i][S_j] = 0
  let M = H * W
  for k in 1 .. M:
    # k回目の計算
    var a2 = a
    for i in H:
      for j in W:
        if i + 1 in 0 ..< H: a2[i + 1][j].max=a[i][j]
        if i - 1 in 0 ..< H: a2[i - 1][j].max=a[i][j]
        if j + 1 in 0 ..< W: a2[i][j + 1].max=a[i][j]
        if j - 1 in 0 ..< W: a2[i][j - 1].max=a[i][j]
    for i in H:
      for j in W:
        a2[i][j].max= a2[i][j] + A[i][j]
    a = a2.move
    if k == K:
      var ans = -int.inf
      for i in H:
        for j in W:
          ans.max=a[i][j]
      echo ans
      return
  var ans = -int.inf
  let d = K - M
  for i in H:
    for j in W:
      ans.max=a[i][j] + A[i][j] * d
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var K = nextInt()
  var S_i = nextInt()
  var S_j = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, K, S_i, S_j, A)
else:
  discard

