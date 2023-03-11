const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import heapqueue

solveProc solve(N:int, M:int, K:int, L:int, A:seq[int], B:seq[int], U:seq[int], V:seq[int], C:seq[int]):
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(U[i], V[i], C[i])
  var q = initHeapQueue[tuple[d, u, f:int]]() # 距離, 人, 人気者の属する国
  var dist = Seq[N: Array[2: tuple[d, f:int]]] # 距離, 人気者の属する国
  for u in N:
    for i in 0 .. 1:
      dist[u][i] = (int.inf, -1)
  proc update(v: var array[2, tuple[d, f:int]], d, f:int):bool =
    if v[^1].d <= d: return false
    if v[0].f == f:
      if v[0].d <= d: return false
      v[0] = (d, f)
    elif v[1].f == f:
      if v[1].d <= d: return false
      v[1] = (d, f)
    else:
      v[1] = (d, f)
    if v[0].d > v[1].d: swap v[0], v[1]
    return true
  for i in L:
    # 人B[i]は人気者で国A[B[i]]に属する
    q.push((0, B[i], A[B[i]]))
  while q.len > 0:
    let (d, u, f) = q.pop()
    if not update(dist[u], d, f): continue
    for e in g[u]:
      let d2 = d + e.weight
      q.push((d2, e.dst, f))
  var ans = Seq[int]
  for u in N:
    for i in 0 .. 1:
      if dist[u][i].f != -1 and dist[u][i].f != A[u]:
        ans.add dist[u][i].d
        break
      if i == 1: ans.add -1
  echo ans.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var L = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(L, nextInt())
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, K, L, A.pred, B.pred, U.pred, V.pred, C)
else:
  discard

