const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, W:int, S:seq[string]):
  var p = Seq[(int, int)]
  for i in H:
    for j in W:
      if S[i][j] == 'o':
        p.add (i, j)
  echo abs(p[0][0] - p[1][0]) + abs(p[0][1] - p[1][1])
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

