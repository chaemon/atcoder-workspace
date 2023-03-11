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
import lib/other/bitutils

import lib/other/operator

var v = mint(29) / mint(37)

echo v.estimateRational()

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
  adj := Array[-1 .. B, -1 .. B: seq[tuple[x, y, d:int]]]
  proc isCorner(x, y:int):bool =
    x == 0 or x == H - 1 or y == 0 or y == W - 1
  var corners = Seq[(int, int)]
  for x in 0 ..< H:
    for y in 0 ..< W:
      if isCorner(x, y): corners.add (x, y)
  for x in 0 ..< H:
    for y in 0 ..< W:
      for (x2, y2) in (x, y).neighbor(dir8):
        if x2 in 0 ..< H and y2 in 0 ..< W:
          if C[x2][y2] == 'O': continue
          adj[x][y].add (x2, y2, 1)
      if isCorner(x, y):
        var
          (x0, y0) = (x, y)
        if x == 0:
          x0.dec
        elif x == H - 1:
          x0.inc
        if y == 0:
          y0.dec
        elif y == W - 1:
          y0.inc
        adj[x][y].add (x0, y0, 0)
        for (x2, y2) in corners:
          if abs(x2 - x) <= 1 and abs(y2 - y) <= 1: continue
          #if abs(x2 - x) + abs(y2 - y) <= 1: continue
          if C[x2][y2] == 'O': continue
          adj[x0][y0].add (x2, y2, 1)
  var
    ans_d = int.inf
    ans_ct = mint(0)
  block:
    # 2の場合を先にやる
    for i, (x, y) in corners:
      if C[x][y] != '.': continue
      for j in i + 1 ..< corners.len:
        let (x2, y2) = corners[j]
        if abs(x2 - x) > 1 or abs(y2 - y) > 1: continue
        if C[x2][y2] != '.': continue
        var C = C
        C[x][y] = '#'
        C[x2][y2] = '#'
        var
          vis = Seq[H, W: false]
        proc dfs(x, y: int):bool =
          if vis[x][y]: return false
          vis[x][y] = true
          if (x, y) == (gx, gy): return true
          for (x2, y2) in (x, y).neighbor(dir4):
            if x2 notin 0 ..< H or y2 notin 0 ..< W: continue
            if C[x2][y2] == '#': continue
            if dfs(x2, y2): return true
          return false
        if not dfs(sx, sy):
          if ans_d > 2:
            ans_d = 2
            ans_ct = 1
          elif ans_d == 2:
            ans_ct += 1
    if ans_d != int.inf:
      doAssert ans_d == 2
      echo YES
      echo ans_d, " ", ans_ct
      return
  a[sx][sy] = -1
  a[gx][gy] = -1
  dist := Array[-1 .. B, -1 .. B, 0 .. 1: tuple[d:int, c:mint]]
  vis := Array[-1 .. B, -1 .. B, 0 .. 1: bool]
  # (-1, 0): 2, 3以外から (-1, 2): 2から来た, (-1, 3): 3から来た
  for (x0, y0) in v:
    if (x0, y0) == (sx, sy) or (x0, y0) == (gx, gy): continue
    if C[x0][y0] == '.':
      #q := initHeapQueue[tuple[d, o, x, y, t:int]]()
      q := initDeque[tuple[x, y, t:int]]()
      vis.fill(false)
      dist.fill((int.inf, mint(0)))
      # (x, y, 0)から(x, y, 1)へのパスを探す
      
      dist[x0][y0][0] = (0, mint(1))
      q.addLast((x0, y0, 0))
      while q.len > 0:
        let (x, y, t) = q.popFirst
        if vis[x][y][t]: continue
        vis[x][y][t] = true
        for (x2, y2, s) in adj[x][y]:
          if a[x2][y2] == -1: continue
          var t2 = t
          if (a[x][y] == 2 and a[x2][y2] == 3) or (a[x][y] == 3 and a[x2][y2] == 2):
            t2 = 1 - t2
          let d2 = dist[x][y][t].d + s
          if dist[x2][y2][t2].d > d2:
            doAssert not vis[x2][y2][t2]
            dist[x2][y2][t2].d = d2
            dist[x2][y2][t2].c = dist[x][y][t].c
            if s == 1:
              q.addLast((x2, y2, t2))
            else:
              q.addFirst((x2, y2, t2))
          elif dist[x2][y2][t2].d == d2:
            doAssert not vis[x2][y2][t2]
            dist[x2][y2][t2].c += dist[x][y][t].c
      let (d, ct) = dist[x0][y0][1]
      if ans_d > d:
        ans_d = d
        ans_ct = ct
      elif ans_d == d:
        ans_ct += ct
    a[x0][y0] = -1
  if ans_d == int.inf:
    echo NO
  else:
    echo YES
    echo ans_d, " ", ans_ct / 2
  Naive:
    var sx, sy, gx, gy:int
    for x in H:
      for y in W:
        if C[x][y] == 'S': (sx, sy) = (x, y)
        elif C[x][y] == 'G': (gx, gy) = (x, y)
    var v = collect(newSeq):
      for x in H:
        for y in W:
          if C[x][y] == '.': (x:x, y:y)
    var
      ans_d = int.inf
      ans_ct = 0
    for b in 1 shl v.len:
      var
        C = C
        d = 0
      for i in v.len:
        if b[i] == 1:
          d.inc
          let (x, y) = v[i]
          C[x][y] = '#'
      var
        vis = Seq[H, W: false]
      proc dfs(x, y: int):bool =
        if vis[x][y]: return false
        vis[x][y] = true
        if (x, y) == (gx, gy): return true
        for (x2, y2) in (x, y).neighbor(dir4):
          if x2 notin 0 ..< H or y2 notin 0 ..< W: continue
          if C[x2][y2] == '#': continue
          if dfs(x2, y2): return true
        return false
      if not dfs(sx, sy):
        if ans_d > d:
          ans_d = d
          ans_ct = 1
        elif ans_d == d:
          ans_ct += 1
    if ans_d == int.inf:
      echo NO
    else:
      echo YES
      echo ans_d, " ", ans_ct
  discard
 
when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var C = newSeqWith(H, nextString())
  solve(H, W, C)
  #test(H, W, C)
else:
  discard
