when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

var dir = [(0, 1), (1, 0), (0, -1), (-1, 0)]

solveProc solve(H:int, W:int, S:seq[string], A:int, B:int, C:int, D:int):
  Pred A, B, C, D
  var
    q = initDeque[(int, int)]()
    dist = Seq[H, W: int.inf]
    vis = Seq[H, W: false]
  dist[A][B] = 0
  q.addLast((A, B))
  while q.len > 0:
    let (x, y) = q.popFirst
    if x == C and y == D:
      echo dist[x][y];return
    vis[x][y] = true
    # 上下左右に移動
    for (dx, dy) in dir:
      let
        x2 = x + dx
        y2 = y + dy
      if x2 notin 0 ..< H or y2 notin 0 ..< W or S[x2][y2] == '#' or vis[x2][y2]: continue
      if dist[x][y] < dist[x2][y2]:
        dist[x2][y2] = dist[x][y]
        q.addFirst((x2, y2))
    # 前蹴り
    for (dx, dy) in dir:
      for p in 1 .. 2:
        let
          x2 = x + dx * p
          y2 = y + dy * p
        if x2 notin 0 ..< H or y2 notin 0 ..< W or vis[x2][y2]: continue
        if dist[x][y] + 1 < dist[x2][y2]:
          dist[x2][y2] = dist[x][y] + 1
          q.addLast((x2, y2))

  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(H, W, S, A, B, C, D)
else:
  discard

