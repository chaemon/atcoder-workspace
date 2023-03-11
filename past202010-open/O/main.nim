include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

const DEBUG = true

# Failed to predict input format
block main:
  let N, M = nextInt()
  g := initGraph[int](N + 1)
  let a = Seq[N: nextInt()]
  for i in 0..<N:
    g.addEdge(i, i + 1, a[i])
    g.addEdge(i + 1, i, 0)
  for i in 0..<M:
    let l, r = nextInt() - 1
    let c = nextInt()
    g.addEdge(l, r + 1, c)
  dist := g.dijkstra(0)
  echo a.sum - dist[N]
