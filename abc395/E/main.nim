when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template, lib/graph/dijkstra

solveProc solve(N:int, M:int, X:int, u:seq[int], v:seq[int]):
  Pred u, v
  proc id(u, t:int):int =
    u * 2 + t
  var g = initGraph[int](2 * N)
  for u in N:
    g.addBiEdge(id(u, 0), id(u, 1), X)
  for i in M:
    let (u, v) = (u[i], v[i])
    g.addEdge(id(u, 0), id(v, 0), 1)
    g.addEdge(id(v, 1), id(u, 1), 1)
  var
    d = g.dijkstra(id(0, 0))
    ans = int.inf
  for t in 2:
    ans.min=d[id(N - 1, t)]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, X, u, v)
else:
  discard

