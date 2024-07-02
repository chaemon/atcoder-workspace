when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const dir = [(0, 1), (1, 0), (0, -1), (-1, 0)]

solveProc solve(N:int, S:seq[string]):
  var s:seq[(int, int)]
  for i in N:
    for j in N:
      if S[i][j] == 'P':
        s.add (i, j)
  var
    dist = Seq[N, N, N, N: int.inf]
    q = initDeque[(int, int, int, int)]()
  dist[s[0][0]][s[0][1]][s[1][0]][s[1][1]] = 0
  dist[s[1][0]][s[1][1]][s[0][0]][s[0][1]] = 0
  q.addLast (s[0][0], s[0][1], s[1][0], s[1][1])
  proc next(x, y, dx, dy: int):(int, int) =
    let
      x1 = x + dx
      y1 = y + dy
    if x1 notin 0 ..< N or y1 notin 0 ..< N or S[x1][y1] == '#': return (x, y)
    else: return (x1, y1)
  while q.len > 0:
    let (ax, ay, bx, by) = q.popFirst
    #debug ax, ay, bx, by
    if ax == bx and ay == by:
      echo dist[ax][ay][bx][by]
      return
    for (dx, dy) in dir:
      let
        (nax, nay) = next(ax, ay, dx, dy)
        (nbx, nby) = next(bx, by, dx, dy)
      let d = dist[ax][ay][bx][by] + 1
      if dist[nax][nay][nbx][nby] > d:
        dist[nax][nay][nbx][nby] = d
        dist[nbx][nby][nax][nay] = d
        q.addLast (nax, nay, nbx, nby)
  echo -1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

