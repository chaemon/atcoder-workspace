include atcoder/extra/header/chaemon_header
import heapqueue

import atcoder/extra/graph/graph_template

#const DEBUG = true

type S = object
  d, u:int

`<`(a,b:S) => a.d < b.d

proc solve(N:int, M:int, X:int, Y:int, A:seq[int], B:seq[int], T:seq[int], K:seq[int]) =
  g := initGraph[tuple[T, K:int]](N)
  for i in 0..<M:
    g.addBiEdge(A[i], B[i], (T[i], K[i]))
  var q = initHeapQueue[S]()
  var dist = Seq(N, int.inf)
  q.push(S(d:0, u:X))
  while q.len > 0:
    s := q.pop()
    let d = s.d
    let u = s.u
    if dist[u] != int.inf: continue
    dist[u] = d
    debug u, d
    for e in g[u]:
      let (T, K) = e.weight
      var d = ((d + K - 1) div K) * K
      debug e.src, e.dst, d, d + T
      d += T
      debug u, dst, d
      if dist[u] < d:
        q.push(S(d:d, u:e.dst))
  if dist[Y] == int.inf:
    echo -1
  else:
    echo dist[Y]
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var X = nextInt() - 1
  var Y = nextInt() - 1
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var T = newSeqWith(M, 0)
  var K = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    T[i] = nextInt()
    K[i] = nextInt()
  solve(N, M, X, Y, A, B, T, K)
#}}}
