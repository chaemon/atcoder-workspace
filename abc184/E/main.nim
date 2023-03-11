include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra


proc solve() =
  let H, W = nextInt()
  let a = newSeqWith(H, nextString())
  proc id(x, y:int):int =
    x * W + y
  proc id(c:char):int = H * W + c.ord - 'a'.ord
  var g = initGraph[int32](H * W + 26)
  var sid, gid:int
  for i in 0..<H:
    for j in 0..<W:
      if a[i][j] == '#': continue
      let t = id(i, j)
      if i + 1 < H and a[i + 1][j] != '#': g.addBiEdge(t, id(i + 1, j), 1)
      if j + 1 < W and a[i][j + 1] != '#': g.addBiEdge(t, id(i, j + 1), 1)
      if a[i][j].ord in 'a'.ord..'z'.ord:
        let u = id(a[i][j])
        g.addEdge(t, u, 0)
        g.addEdge(u, t, 1)
      if a[i][j] == 'S':sid = id(i, j)
      if a[i][j] == 'G':gid = id(i, j)
  var (dist, prev) = g.dijkstra01(sid)
  echo if dist[gid] == int32.inf: -1 else: dist[gid]
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
