const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/graph/graph_template
import heapqueue

solveProc solve(N:int, M:int, v:int, A:seq[int], B:seq[int], C:seq[int]):
  var g, h = initGraph(N)
  for i in M:
    g.addEdge(A[i], B[i], C[i])
    h.addEdge(B[i], A[i], C[i])
  var
    vis = Seq[N, 2:false] # node, turn(0: takahashi, 1:aoki)
    ct = Seq[N: 0] # 隣接する頂点でinfになったもの
    cost = Seq[N, 2: int.inf]
    #q = initDeque[(int, int)]()
    q = initHeapQueue[(int, int, int)]()
  for u in N:
    cost[u][0] = int.inf
    cost[u][1] = -int.inf
  for u in N:
    if g[u].len == 0:
      for t in 2:
        q.push((0, u, t))
        cost[u][t] = 0
  while q.len > 0:
    let (c, u, t) = q.pop()
    if vis[u][t]: continue
    vis[u][t] = true
    if t == 0: # takahashi
      for e in h[u]:
        ct[e.dst].inc
        # (e.dst, 1) -> (u, 0)
        cost[e.dst][1].max= cost[u][0] + e.weight
        if ct[e.dst] == g[e.dst].len: # どこに行ってもfinite
          q.push((c + e.weight, e.dst, 1))
    else: # aoki
      for e in h[u]:
        # (e.dst, 0) -> (u, 1)
        cost[e.dst][0].min= cost[u][1] + e.weight
        q.push((c + e.weight, e.dst, 0))
  let ans = cost[v][0]
  if ans == int.inf:
    echo "INFINITY"
  else:
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var v = nextInt() - 1
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    C[i] = nextInt()
  solve(N, M, v, A, B, C)
else:
  discard

