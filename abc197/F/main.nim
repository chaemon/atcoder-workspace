include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra_new

#const DEBUG = true

### Failed to predict input format
#block main:
#  var N, M = nextInt()
#  var A, B, C = Seq[M : int]
#  for i in 0..<M:
#    A[i] = nextInt()-1
#    B[i] = nextInt()-1
#    C[i] = nextString()[0].ord - 'a'.ord
#  for i in 0..<M:
#    A.add(B[i])
#    B.add(A[i])
#    C.add(C[i])
#  debug A, B, C
#  M *= 2
#  g := initGraph[int](N * N)
#  for i in 0..<M:
#    for j in 0..<M:
#      if C[i] != C[j]: continue
#      let
#        f = A[i] * N + A[j]
#        t = B[i] * N + B[j]
#      g.addEdge(f, t, 1)
#  let (dist, prev) = g.dijkstra01(0 * N + N - 1)
#  var ans = int.inf
#  for u in 0..<N:
#    ans.min=dist[u * N + u] * 2
#  for i in 0..<M:
#    let d = dist[A[i] * N + B[i]]
#    if d != int.inf:
#      ans.min=d * 2 + 1
#  if ans == int.inf:
#    echo -1
#  else:
#    echo ans
#  discard

type U = (int,int)

block main:
  var N, M = nextInt()
  var A, B, C = Seq[M : int]
  for i in 0..<M:
    A[i] = nextInt()-1
    B[i] = nextInt()-1
    C[i] = nextString()[0].ord - 'a'.ord
  var g = initGraph[int](N)
  for i in 0..<M:
    g.addBiEdge(A[i], B[i], C[i])
  id(u:(int, int)) => u[0] * N + u[1]
  proc adj(u:U):auto =
    result = newSeq[(U, int)]()
    let (u, v) = u
    for eu in g[u]:
      for ev in g[v]:
        if eu.weight != ev.weight: continue
        result.add ((eu.dst, ev.dst), 1)
  #iterator adj(u:U):tuple[dst:U, weight:int] {.closure.} =
  #  echo "adjcall: ", u
  #  let (u, v) = u
  #  # type 1
# #   for eu in g[u]:
# #   type 2
  #  debug u, g[u].len
  #  for i in 0..<g[u].len:
  #    let eu = g[u][i]
  #    debug eu
  #    debug v, g[v].len
  #    for ev in g[v]:
  #      debug ev
  #      if eu.weight != ev.weight: continue
  #      yield ((eu.dst, ev.dst), 1)
  #      echo "end of ev loop"
  #    echo "end of eu loop"
  #  echo "end of adj iterator"
  var G = initGraphProc[int, (int,int)](N * N, id, adj)
#  for u in 0..<N:
#    for v in 0..<N:
#      for eu in g[u]:
#        for ev in g[v]:
#          if eu.weight != ev.weight: continue
#          G.addEdge((u, v), (eu.dst, ev.dst), 1)

#  let (dist, prev) = G.dijkstra01((0, N - 1))
  let (dist, prev) = G.dijkstra((0, N - 1))
  var ans = int.inf
  for u in 0..<N:
    ans.min=dist[G.id((u, u))] * 2
  for i in 0..<M:
    let d = min(dist[G.id((A[i], B[i]))], dist[G.id((B[i], A[i]))])
    if d != int.inf:
      ans.min=d * 2 + 1
  if ans == int.inf:
    echo -1
  else:
    echo ans
  discard


