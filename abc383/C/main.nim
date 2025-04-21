when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, D:int, S:seq[string]):
  var
    q = initDeque[tuple[x, y:int]]()
    dist = Seq[H, W: int.inf]
    vis = Seq[H, W: false]
  for i in H:
    for j in W:
      if S[i][j] == 'H':
        dist[i][j] = 0
        q.addLast (i, j)
  while q.len > 0:
    let (x, y) = q.popFirst
    if vis[x][y]: continue
    vis[x][y] = true
    for (dx, dy) in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
      let
        x2 = x + dx
        y2 = y + dy
      if x2 notin 0 ..< H or y2 notin 0 ..< W or S[x2][y2] == '#': continue
      if dist[x2][y2] > dist[x][y] + 1:
        dist[x2][y2] = dist[x][y] + 1
        q.addLast((x2, y2))
  ans := 0
  for i in H:
    for j in W:
      if dist[i][j] <= D: ans.inc
  echo ans

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var D = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, D, S)
else:
  discard

