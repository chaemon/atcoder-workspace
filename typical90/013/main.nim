const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  g := initUndirectedGraph(N, A, B, C)
  var
    dl = g.dijkstra(0)
    dr = g.dijkstra(N - 1)
  for k in N:
    echo dl[k] + dr[k]
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A.pred, B.pred, C)
