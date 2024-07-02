when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/graph/graph_template, lib/graph/dijkstra

solveProc solve(N:int, A:seq[int], B:seq[int], X:seq[int]):
  Pred X
  var g = initGraph[int](N)
  for i in N - 1:
    g.addEdge i, i + 1, A[i]
    g.addEdge i, X[i], B[i]
  var d = g.dijkstra(0)
  echo d[N - 1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  var X = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
    X[i] = nextInt()
  solve(N, A, B, X)
else:
  discard

