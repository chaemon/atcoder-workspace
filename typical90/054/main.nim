const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/graph/graph_template
import lib/graph/dijkstra

# Failed to predict input format
block main:
  let N, M = nextInt()
  var g = initGraph(N + M)
  for i in M:
    let K = nextInt()
    let R = K @ nextInt() - 1
    for r in R:
      g.addEdge r, N + i, 1
      g.addEdge N + i, r, 0
  var dist = g.dijkstra(0)
  for u in N:
    if dist[u] == int.inf:
      echo -1
    else:
      echo dist[u]
  discard

