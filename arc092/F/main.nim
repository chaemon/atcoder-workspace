include atcoder/extra/header/chaemon_header
import atcoder/scc
import atcoder/extra/graph/graph_template

import deques

var N:int
var M:int
var a:seq[int]
var b:seq[int]

proc solve() =
  dists := Seq(N, N, Array(2, int.inf))
  proc update(a:var array[2, int], d:int):bool =
    if d in a: return false
    if a[0] == int.inf: a[0] = d;return true
    if a[1] == int.inf: a[1] = d;return true
    return false
  scc_graph := initSCCGraph(N)
  g := initGraph[int](N)
  for i in 0..<M:
    g.addEdge(a[i], b[i])
    scc_graph.addEdge(a[i], b[i])
  scc := scc_graph.scc()
  var belongs = Seq(N, int)
  for i in scc.len:
    for j in scc[i].len:
      belongs[scc[i][j]] = i
  for s in 0..<N:
    dist =& dists[s]
    q := initDeque[(int,int)]() # dist, id
    for e in g[s]:
      q.addLast((e.dst, e.dst))
      dist[e.dst][0] = e.dst
    while q.len > 0:
      let (d, u) = q.popFirst()
      if u == s: continue
      for e in g[u]:
        if update(dist[e.dst], d):
          q.addLast((d, e.dst))
  for i in 0..<M:
    var same = true
    if belongs[a[i]] != belongs[b[i]]:
      if dists[a[i]][b[i]][1] != int.inf: same = false
    else:
      if dists[a[i]][b[i]][1] == int.inf: same = false
    echo if same: "same" else: "diff"
  return

#{{{ input part
block:
  N = nextInt()
  M = nextInt()
  a = newSeqWith(M, 0)
  b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve()
#}}}

