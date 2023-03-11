const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve(H, W:int, C:seq[string]):
  var a = Seq[H, W: -int.inf]
  a[0][0] = 1
  for i in H:
    for j in W:
      if a[i][j] == -int.inf: continue
      if i + 1 < H and C[i + 1][j] == '.':
        a[i + 1][j].max= a[i][j] + 1
      if j + 1 < W and C[i][j + 1] == '.':
        a[i][j + 1].max= a[i][j] + 1
  ans := -int.inf
  for i in H:
    for j in W:
      ans.max=a[i][j]
  echo ans
  discard

when not DO_TEST:
  let H, W = nextInt()
  let C = Seq[H: nextString()]
  solve(H, W, C)
else:
  discard

