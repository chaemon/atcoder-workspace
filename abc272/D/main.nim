when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int):
  var dir = Seq[(int, int)]
  for x in 0 .. M:
    if x * x > M:
      break
    let
      y2 = M - x * x
      y = int(sqrt(y2.float) + 1e-9)
    if y * y == y2:
      dir.add (x, y)
      dir.add (-x, y)
      dir.add (x, -y)
      dir.add (-x, -y)
  var
    q = initDeque[(int, int)]()
    vis = Seq[N, N: false]
    dist = Seq[N, N: int.inf]
  dist[0][0] = 0
  q.addLast((0, 0))
  while q.len > 0:
    let (x, y) = q.popFirst
    if vis[x][y]: continue
    vis[x][y] = true
    for (dx, dy) in dir:
      let (x2, y2) = (x + dx, y + dy)
      if x2 notin 0 ..< N or y2 notin 0 ..< N: continue
      if dist[x2][y2] <= dist[x][y] + 1: continue
      dist[x2][y2] = dist[x][y] + 1
      q.addLast (x2, y2)
  for i in N:
    for j in N:
      if dist[i][j] == int.inf: dist[i][j] = -1
  for i in N:
    echo dist[i].join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

