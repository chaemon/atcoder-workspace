const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

type P = (int, seq[int])

solveProc solve(M:int, u:seq[int], v:seq[int], p:seq[int]):
  var g = initGraph(9)
  for i in M: g.addBiEdge(u[i], v[i])
  iterator next(a:seq[int]):(seq[int], int) {.closure.} =
    var a = a
    var u = 0
    while u < a.len and a[u] != 8: u.inc
    assert u != a.len
    for e in g[u]:
      swap(a[u], a[e.dst])
      yield (a, 1)
      swap(a[u], a[e.dst])

  var a = newSeqWith(9, 8)
  for j in 0..<8: a[p[j]] = j

  var g2 = initGraph(next)
  var d = g2.dijkstra01(a)
  var a2 = (0..8).toSeq
  if d[a2] == int.inf:
    echo -1
  else:
    echo d[a2]
  return

when not DO_TEST:
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  var p = newSeqWith(8, nextInt() - 1)
  solve(M, u, v, p)
else:
  discard

