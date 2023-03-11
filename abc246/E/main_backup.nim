const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import deques

var
  dist = Array[1500, 1500, 2: int32.inf]
  vis = Array[1500, 1500, 2: false]


solveProc solve(N:int, A_x:int, A_y:int, B_x:int, B_y:int, S:seq[string]):
  var q = initDeque[tuple[x, y, t:int16]]()
  q.addLast((Ax.int16, Ay.int16, 0.int16))
  dist[Ax][Ay][0] = 0
  q.addLast((Ax.int16, Ay.int16, 1.int16))
  dist[Ax][Ay][1] = 0
  while q.len > 0:
    let (x, y, t) = q.popFirst
    if vis[x][y][t]: continue
    vis[x][y][t] = true
    var
      dx = 1.int16
      dy = 1.int16
    if t == 1: dy *= -1
    for (x2, y2) in [(x - dx, y - dy), (x + dx, y + dy)]:
      if x2 notin 0..<N or y2 notin 0..<N or S[x2][y2] == '#': continue
      q.addFirst((x2, y2, t))
      dist[x2][y2][t].min=dist[x][y][t]
    q.addLast((x, y, 1 - t))
    dist[x][y][1 - t].min=dist[x][y][t] + 1
  var ans = min(dist[Bx][By][0], dist[Bx][By][1])
  if ans == int32.inf:
    echo -1
  else:
    echo ans + 1
  discard

when not DO_TEST:
  var N = nextInt()
  var A_x = nextInt() - 1
  var A_y = nextInt() - 1
  var B_x = nextInt() - 1
  var B_y = nextInt() - 1
  var S = newSeqWith(N, nextString())
  solve(N, A_x, A_y, B_x, B_y, S)
else:
  discard

