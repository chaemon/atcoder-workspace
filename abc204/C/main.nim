include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template

const DEBUG = true

proc solve(N:int, M:int, A:seq[int], B:seq[int]) =
  var g = initGraph(N)
  for i in 0..<M:
    g.addEdge(A[i], B[i])
  var vis = Seq[N: false]
  proc dfs(g:Graph, u, p:int) =
    vis[u] = true
    for e in g[u]:
      if e.dst == p or vis[e.dst]: continue
      g.dfs(e.dst, u)
  ans := 0
  for u in 0..<N:
    vis = Seq[N: false]
    g.dfs(u, -1)
    ans += vis.count(true)
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, M, A, B)
#}}}

