const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  Pred A, B
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(A[i], B[i])
  var d = g.dijkstra(0)
  for u in N:
    let d = d[u]
    if d == int.inf:
      echo -1
    else:
      echo d
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

