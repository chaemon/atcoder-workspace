when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/graph/graph_template
import lib/graph/dijkstra
import lib/graph/visualizer

solveProc solve(N:int, A:int, B:int, C:int, D:seq[seq[int]]):
  var
    g = initGraph(N * 2)
    labels = Seq[N * 2:string]
  for u in N:
    labels[u] = fmt"(0, {$u})"
    labels[u + N] = fmt"(1, {$u})"
  for u in N:
    for v in N:
      if u == v: continue
      g.addEdge(u, v, D[u][v] * A)
      g.addEdge(u + N, v + N, D[u][v] * B + C)
    g.addEdge(u, u + N, 0)
  g.visualize(labels = labels)
  var d = g.dijkstra(0)
  echo min(d[N - 1], d[N - 1 + N])
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, A, B, C, D)
else:
  discard

