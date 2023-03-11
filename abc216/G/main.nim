const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N:int, M:int, L:seq[int], R:seq[int], X:seq[int]):
  var g = initGraph(N + 1)
  for u in N:
    g.addEdge(u, u + 1, 1)
    g.addEdge(u + 1, u, 0)
  for i in M:
    # L[i] ..< R[i]
    g.addEdge(L[i], R[i], X[i])
  var dist = g.dijkstra(0)
  var ans = Seq[N:int]
  for i in N:
    if dist[i + 1] - dist[i] == 1:
      ans[i] = 0
    else:
      ans[i] = 1
  echo ans.join(" ")
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  var X = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt() - 1
    R[i] = nextInt()
    X[i] = nextInt()
    X[i] = R[i] - L[i] - X[i]
  solve(N, M, L, R, X)

