const DO_CHECK = true
include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import heapqueue

proc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]) =
  var g = initUndirectedGraph(N, A, B, (0..<M).toSeq)
  var dist = Seq[N: int.inf]
  var vis = Seq[N: false]
  dist[0] = 0
  var q = initHeapQueue[tuple[t, u:int]]()
  q.push((0, 0))
  while q.len > 0:
    let (t, u) = q.pop()
    if vis[u]: continue
    vis[u] = true
    dist[u] = t
    for e in g[u]:
      let i = e.weight
      let d2 = sqrt(D[i].float + 1.0 - 1e-10).int
      let t0 = D[i] div (d2 + 1)
      if t >= t0:
        # go immediately
        q.push((t + C[i] + (D[i] div (t + 1)), e.dst))
      else:
        # wait until t0
        q.push((t0 + C[i] + (D[i] div (t0 + 1)), e.dst))
  if dist[N - 1] == int.inf:
    echo -1
  else:
    echo dist[N - 1]
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  var D = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, M, A, B, C, D)
#}}}
