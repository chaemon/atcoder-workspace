const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra
import lib/other/bitutils

type P = tuple[b, u:int]

solveProc solve(N:int, M:int, u:seq[int], v:seq[int]):
  let NN = 2^N
  var g = initGraph[int](N)
  for i in M: g.addBiEdge(u[i], v[i])
  proc id(p:P):int = p.b + p.u * NN
  proc adj(p:P):seq[(P, int)] =
    let (b, u) = p
    for e in g[u]:
      var b = b
      if b[e.dst] == 0:
        b[e.dst] = 1
      else:
        b[e.dst] = 0
      result.add ((b, e.dst), 1)
  var G = initGraph(N * 2^N, id, adj)
  var ans = Seq[2^N: int.inf]
  ans[0] = 0
  var s = Seq[P]
  for u in N:
    var b = 0
    b[u] = 1
    s.add((b, u))
  var dist = G.dijkstra01(s)
  for u in N:
    for b in 2^N:
      ans[b].min=dist[(b, u)] + 1
  echo ans.sum
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  solve(N, M, u, v)
else:
  discard

