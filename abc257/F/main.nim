const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N: int, M: int, U: seq[int], V: seq[int]):
  Pred U, V
  var
    g = initGraph[int](N + 1)
    h = initGraph[int](N)
  for i in M:
    if U[i] == -1:
      g.addBiEdge(V[i], N, 1)
    else:
      g.addBiEdge(U[i], V[i])
      h.addBiEdge(U[i], V[i])
  var
    d0 = g.dijkstra(0)
    d1 = h.dijkstra(N - 1)
    ans = Seq[int]
  for i in N:
    let d = min(d0[N - 1], d0[N] + d1[i])
    ans.add if d.isInf:
      -1
    else:
      d
  echo ans.join(" ")

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, M, U, V)
else:
  discard
