include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/scc

proc solve() =
  let N, M = nextInt()
  let A = newSeqWith(N, nextInt())
  var X, Y = newSeq[int](M)
  for i in 0..<M:
    X[i] = nextInt() - 1
    Y[i] = nextInt() - 1
  g := initSccGraph(N)
  for i in 0..<M:
    g.addEdge(X[i], Y[i])
  var scc = g.scc
  var belongs = newSeq[int](N)
  var min_val, max_val = newSeq[int](scc.len)
  var m = newSeqWith(scc.len, -int.inf)
  for i in scc.len:
    min_val[i] = int.inf
    max_val[i] = -int.inf
    for j in scc[i]:
      belongs[j] = i
      min_val[i].min=A[j]
      max_val[i].max=A[j]
  g2 := initGraph[int](scc.len)
  for i in 0..<M:
    g2.addEdge(belongs[X[i]], belongs[Y[i]])
  var vis = newSeqWith(scc.len, false)
  proc dfs(u:int, p:int) =
    if vis[u]: return
    vis[u] = true
    m[u] = -int.inf
    for e in g2[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
      m[u].max=max_val[e.dst]
      m[u].max=m[e.dst]
  for u in scc.len:
    dfs(u, -1)
  var ans = -int.inf
  for u in scc.len:
    b := min_val[u]
    s := -int.inf
    if scc[u].len != 1:
      s.max=max_val[u]
    s.max=m[u]
    ans.max=s - b
  echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
