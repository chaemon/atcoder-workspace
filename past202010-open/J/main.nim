include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

const DEBUG = true

# Failed to predict input format
block main:
  let N, M = nextInt()
  let XAB, XAC, XBC = nextInt()
  let S = nextString()
  var g = initGraph[int](N + 6)
  # AB(N), BA(N+1), BC(N+2), CB(N+3), CA(N+4), AC(N+5)
  for u in 0..<N:
    if S[u] == 'A':
      g.addEdge(u, N, XAB)
      g.addEdge(u, N + 5, XAC)
      g.addEdge(N + 1, u, 0)
      g.addEdge(N + 4, u, 0)
    elif S[u] == 'B':
      g.addEdge(u, N + 1, XAB)
      g.addEdge(u, N + 2, XBC)
      g.addEdge(N, u, 0)
      g.addEdge(N + 3, u, 0)
    elif S[u] == 'C':
      g.addEdge(u, N + 3, XBC)
      g.addEdge(u, N + 4, XAC)
      g.addEdge(N + 2, u, 0)
      g.addEdge(N + 5, u, 0)
    else: assert false
  for i in 0..<M:
    let A, B = nextInt() - 1
    let C = nextInt()
    g.addBiEdge(A, B, C)
  let dist = g.dijkstra(0)
  echo dist[N - 1]
  discard

