const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/direction

const YES = "Yes"
const NO = "No"
import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import std/heapqueue

const B = 100

solveProc solve(H:int, W:int, C:seq[string]):
  var
    a = Array[-1 .. B, -1 .. B: 0] # 0: . 1: O, -1:壁を置けない, 2: path上, 3: pathの隣接点
    sx, sy, gx, gy: int
    v = Seq[tuple[x, y:int]]
  for i in H:
    for j in W:
      if C[i][j] == 'S':
        (sx, sy) = (i, j)
      elif C[i][j] == 'G':
        (gx, gy) = (i, j)
      elif C[i][j] == 'O':
        a[i][j] = -1
      elif C[i][j] == '.':
        a[i][j] = 0
  block:
    var (x, y) = (sx, sy)
    while gx > x:
      v.add (x, y)
      x.inc
    while gx < x:
      v.add (x, y)
      x.dec
    while gy > y:
      v.add (x, y)
      y.inc
    while gy < y:
      v.add (x, y)
      y.dec
    doAssert (x, y) == (gx, gy)
    v.add (x, y)
  for (x, y) in v:
    a[x][y] = 2
  # 2に隣接する最短経路を作る
  block:
    proc valid(x, y:int):bool =
      if a[x][y] == 2: return false
      for (x2, y2) in (x, y).neighbor(dir4):
        if x2 notin -1 .. H or y2 notin -1 .. W: continue
        if a[x2][y2] == 2: return true
      return false
    var
      q = initDeque[(int, int)]()
      dist = Array[-1 .. B, -1 .. B: int.inf]
      vis = Array[-1 .. B, -1 .. B: false]
      prev = Array[-1 .. B, -1 .. B: (int, int)]
    q.addLast((sx, sy))
    dist[sx][sy] = 0
    while q.len > 0:
      let (x, y) = q.popFirst
      if vis[x][y]: continue
      vis[x][y] = true
      for (x2, y2) in (x, y).neighbor(dir4):
        if x2 notin -1 .. H or y2 notin -1 .. W: continue
        if (x2, y2) != (sx, sy) and (x2, y2) != (gx, gy) and not valid(x2, y2): continue
        if dist[x2][y2] > dist[x][y] + 1:
          dist[x2][y2] = dist[x][y] + 1
          prev[x2][y2] = (x, y)
          q.addLast((x2, y2))
    var (x, y) = (gx, gy)
    while true:
      if (x, y) == (sx, sy): break
      if (x, y) != (gx, gy):
        a[x][y] = 3
      (x, y) = prev[x][y]
  #for i in -1 .. H:
  #  echo a[i][-1 .. W].join(" ")
  proc isCorner(x, y:int):bool =
    x == 0 or x == H - 1 or y == 0 or y == W - 1
  proc get_neighbor(p: tuple[x, y:int]):seq[tuple[x, y:int]] =
    let (x, y) = p
    if x == -1:
      for x2 in H:
        for y2 in W:
          if x2 == 0 or x2 == H - 1 or y2 == 0 or y2 == W - 1:
            result.add (x2, y2)
    else:
      doAssert x in 0 ..< H and y in 0 ..< W
      for (x2, y2) in (x, y).neighbor(dir8):
        if isCorner(x, y) and isCorner(x2, y2): continue # 端から端の移動は禁止
        result.add (x2, y2)
  var
    ans_d = int.inf
    ans_ct = mint(0)
  a[-1][2] = 2
  a[-1][3] = 3
  a[sx][sy] = -1
  a[gx][gy] = -1
  dist := Array[-1 .. B, -1 .. B, 0 .. 1: tuple[d:int, c:mint]]
  vis := Array[-1 .. B, -1 .. B, 0 .. 1: bool]
  # (-1, 0): 2, 3以外から (-1, 2): 2から来た, (-1, 3): 3から来た
  for (x0, y0) in v:
    if (x0, y0) == (sx, sy) or (x0, y0) == (gx, gy): continue
    if C[x0][y0] == '.':
      debug x0, y0
      q := initHeapQueue[tuple[d, o, x, y, t:int]]()
      vis.fill(false)
      #q := initDeque[tuple[x, y, t:int]]()
      dist.fill((int.inf, mint(0)))
      # (x, y, 0)から(x, y, 1)へのパスを探す
      
      dist[x0][y0][0] = (0, mint(1))
      q.push((0, 0, x0, y0, 0))
      while q.len > 0:
        let (d, o, x, y, t) = q.pop
        if vis[x][y][t]: continue
        vis[x][y][t] = true
        debug (x, y, t)
 
        var found_out = false
        for (x2, y2) in (x, y).get_neighbor():
          if (x2 in 0 ..< H and y2 in 0 ..< W and C[x2][y2] == 'O') or a[x2][y2] == -1: continue
          var (x2, y2) = (x2, y2)
          if x2 notin 0 ..< H or y2 notin 0 ..< W:
            if found_out: continue
            found_out = true
            x2 = -1
            if a[x][y] == 2:
              y2 = 2
            elif a[x][y] == 3:
              y2 = 3
            else:
              y2 = 0
          var t2 = t
          if (a[x][y] == 2 and a[x2][y2] == 3) or (a[x][y] == 3 and a[x2][y2] == 2):
            t2 = 1 - t2
          var
            d = dist[x][y][t].d
            d2 = dist[x][y][t].d
          if x2 in 0 ..< H and y2 in 0 ..< W: d2.inc
          debug (x2, y2, t2, d2)
          if dist[x2][y2][t2].d > d2:
            dist[x2][y2][t2].d = d2
            dist[x2][y2][t2].c = dist[x][y][t].c
            if d == d2:
              q.push((d2, 1, x2, y2, t2))
            else:
              q.push((d2, 0, x2, y2, t2))
          elif dist[x2][y2][t2].d == d2:
            dist[x2][y2][t2].c += dist[x][y][t].c
      let (d, ct) = dist[x0][y0][1]
      debug d, ct
      if ans_d > d:
        ans_d = d
        ans_ct = ct
      elif ans_d == d:
        ans_ct += ct
    a[x0][y0] = -1
  if ans_d == int.inf:
    echo No
  else:
    echo YES
    echo ans_d, " ", ans_ct / 2
  discard
 
when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var C = newSeqWith(H, nextString())
  solve(H, W, C)
else:
  discard
