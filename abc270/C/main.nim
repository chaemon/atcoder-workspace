when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N:int, X:int, Y:int, U:seq[int], V:seq[int]):
  var g = initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(U[i], V[i])
  var d = g.dijkstra(X)
  var p = d.path(Y)
  p = p.mapIt(it + 1)
  echo p.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var U = newSeqWith(N-1, 0)
  var V = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, X.pred, Y.pred, U.pred, V.pred)
else:
  discard

