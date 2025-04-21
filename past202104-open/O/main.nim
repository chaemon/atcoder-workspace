when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include atcoder/extra/header/chaemon_header
import lib/graph/graph_template
import lib/graph/warshall_floyd
import lib/graph/dijkstra
import lib/tree/doubling_lowest_common_ancestor
import sugar

proc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, u:seq[int], v:seq[int]) =
  Pred a, b, u, v
  var g, h = initGraph(N)
  for i in M:
    g.addBiEdge a[i], b[i], 1
  var
    vis = Seq[N: false]
    w:seq[int] # 余分な辺
  proc dfs(u:int, p = -1) =
    vis[u] = true
    for e in g[u]:
      if e.dst == p: continue
      if vis[e.dst]:
        if u < e.dst:
          w.add u
          w.add e.dst
        continue
      h.addBiEdge(u, e.dst)
      dfs(e.dst, u)
  dfs(0)
  var
    dc = h.initDoublingLowestCommonAncestor(0)
    dist = [w.len, w.len] @ int.inf
    di = collect:
      for i in w.len:
        h.dijkstra01(w[i])
  for i in w.len:
    dist[i][i] = 0
    for j in i + 1 ..< w.len:
      let d = dc.dist(w[i], w[j])
      dist[i][j].min=d
      dist[j][i].min=d
  doAssert false
  #distに対してwarshall floydがいる
  #debug w
  let c = w.len div 2
  for i in c:
    dist[i * 2][i * 2 + 1].min=1
    dist[i * 2 + 1][i * 2].min=1
  var wf = warshallFloyd(dist)
  for q in Q:
    let (u, v) = (u[q], v[q])
    var ans = dc.dist(u, v)
    for i in w.len:
      for j in i + 1 ..< w.len:
        # u -> w[i] -> w[j] -> v
        let d = wf[i, j]
        ans.min= di[i][u] + d + di[j][v]
        ans.min= di[j][u] + d + di[i][v]
    echo ans
  doAssert false
  return

block:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var u = newSeqWith(Q, 0)
  var v = newSeqWith(Q, 0)
  for i in 0..<Q:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, a, b, Q, u, v)
