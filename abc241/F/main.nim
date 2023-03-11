const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra


solveProc solve(H:int, W:int, N:int, s_x:int, s_y:int, g_x:int, g_y:int, X:seq[int], Y:seq[int]):
  var row, col = initTable[int, seq[int]]()
  for i in N:
    row[X[i]].add Y[i]
    col[Y[i]].add X[i]
  for k,v in row.mpairs: v.sort
  for k,v in col.mpairs: v.sort
#  iterator adj(p:tuple[x, y:int]):(tuple[x, y:int], int) {.closure.} =
  proc adj(p:tuple[x, y:int]):seq[(tuple[x, y:int], int)] =
    let (x, y) = p
    if x in row:
      let i = row[x].lowerBound(y)
      # test i - 1, i
      if i - 1 >= 0:
        result.add(((x, row[x][i - 1] + 1), 1))
      if i < row[x].len:
        result.add(((x, row[x][i] - 1), 1))
    if y in col:
      let j = col[y].lowerBound(x)
      # test j - 1, j
      if j - 1 >= 0:
        result.add(((col[y][j - 1] + 1, y), 1))
      if j < col[y].len:
        result.add(((col[y][j] - 1, y), 1))

  var g = initGraph(adj)
  var dist = g.dijkstra01((sx, sy))
  if (gx, gy) notin dist:
    echo -1
  else:
    echo dist[(gx, gy)]
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var s_x = nextInt()
  var s_y = nextInt()
  var g_x = nextInt()
  var g_y = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(H, W, N, s_x, s_y, g_x, g_y, X, Y)
else:
  discard

