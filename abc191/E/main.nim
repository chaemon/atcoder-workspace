include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

const DEBUG = true

# Failed to predict input format
block main:
  let N, M = nextInt()
  let (A, B, C) = unzip(M, (nextInt() - 1, nextInt() - 1, nextInt()))
  g := initGraph[int](N)
  for i in 0..<M:
    g.addEdge(A[i], B[i], C[i])
  var dist = Seq(N, seq[int])
  for u in 0..<N:
    dist[u] = g.dijkstra(u)[0]
  var ans = Seq(N, int.inf)
  for i in M:
    if A[i] == B[i]:
      ans[A[i]].min=C[i]
    else:
      ans[A[i]].min=dist[B[i]][A[i]] + C[i]
  for u in 0..<N:
    if ans[u] == int.inf:
      echo -1
    else:
      echo ans[u]
  discard

