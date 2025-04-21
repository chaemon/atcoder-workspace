when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import deques
import lib/other/bitutils

let d = @[(1, 0), (0, 1), (-1, 0), (0, -1)]

solveProc solve(H:int, W:int, S:seq[string]):
  var
    q = initdeQue[tuple[b, x, y:int]]()
    b = 0
  for i in H:
    for j in W:
      if S[i][j] == '#':
        b[i * W + j] = 1
  var
    dist = Seq[2^(H * W), H, W: int.inf]
    vis = Seq[2^(H * W), H, W: false]
  q.addLast((b, 0, 0))
  dist[b][0][0] = 0
  while q.len > 0:
    let (b, x, y) = q.popFirst()
    if vis[b][x][y]: continue
    vis[b][x][y] = true
    if b == 0:
      echo dist[b][x][y];return
    for (dx, dy) in d:
      let
        x2 = x + dx
        y2 = y + dy
      if x2 notin 0 ..< H or y2 notin 0 ..< W: continue
      let b2 = b xor [x2 * W + y2]
      if dist[b][x][y] + 1 < dist[b2][x2][y2]:
        dist[b2][x2][y2] = dist[b][x][y] + 1
        q.addLast((b2, x2, y2))

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

