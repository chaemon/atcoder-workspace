when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

solveProc solve(N:seq[int], M:int, a:seq[int], b:seq[int]):
  Pred a, b
  var g = initGraph[int](N[0] + N[1])
  for i in M:
    g.addBiEdge(a[i], b[i])
  var
    d1 = g.dijkstra(0)
    d2 = g.dijkstra(N[0] + N[1] - 1)
    d1_max = -int.inf
    d2_max = -int.inf
  for u in 0 ..< N[0]:
    d1_max.max= d1[u]
  for u in N[0] ..< N[0] + N[1]:
    d2_max.max= d2[u]
  doAssert d1_max < int.inf and d2_max < int.inf
  echo d1_max + d2_max + 1
  discard

when not defined(DO_TEST):
  var N = newSeqWith(2, nextInt())
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, M, a, b)
else:
  discard

