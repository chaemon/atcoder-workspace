const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N:int, M:int, H:seq[int], U:seq[int], V:seq[int]):
  g := initGraph[int](N)
  for i in M:
    let d = H[V[i]] - H[U[i]]
    if d > 0:
      g.addEdge(U[i], V[i], d)
      g.addEdge(V[i], U[i], 0)
    else:
      g.addEdge(U[i], V[i], 0)
      g.addEdge(V[i], U[i], -d)
  dist := g.dijkstra(0)
  ans := 0
  for u in N:
    d := H[0] - H[u]
    if d < 0: continue
    ans.max= d - dist[u]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var H = newSeqWith(N, nextInt())
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  solve(N, M, H, U, V)
else:
  discard

