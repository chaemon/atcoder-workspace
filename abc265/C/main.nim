const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, W:int, G:seq[string]):
  var vis = Seq[H, W: false]
  var i, j = 0
  while true:
    if vis[i][j]:
      echo -1;return
    vis[i][j] = true
    if G[i][j] == 'U':
      if i > 0: i.dec;continue
    elif G[i][j] == 'D':
      if i < H - 1: i.inc;continue
    elif G[i][j] == 'L':
      if j > 0: j.dec; continue
    elif G[i][j] == 'R':
      if j < W - 1: j.inc;continue
    echo i + 1, " ", j + 1;return
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var G = newSeqWith(H, nextString())
  solve(H, W, G)
else:
  discard

