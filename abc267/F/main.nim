const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/tree/tree_diameter

solveProc solve(N:int, A:seq[int], B:seq[int], Q:int, U:seq[int], K:seq[int]):
  g := initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(A[i], B[i])
  var
    (l, path) = g.treeDiameter()
    on_path = Seq[N: false]
    pos = Seq[N: -1]
    root = Seq[N: -1]
  for i,u in path:
    on_path[u] = true
    pos[u] = i
  height := Seq[N: int]
  a := Seq[N: seq[int]]
  proc dfs(u, p, r, h: int) =
    height[u] = h
    root[u] = r
    if p != -1:
      a[u].add p
      
    for e in g[u]:
      if on_path[e.dst] or e.dst == p: continue
      dfs(e.dst, u, r, h + 1)
  for u in path:
    dfs(u, -1, u, 0)
  for i in Q:
    if height[U[i]] >= K[i]:
      discard
    else:
      let k = K[i] - height[U[i]]
      let r = root[U[i]]
      if pos[r] * 2 <= l:
      discard
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
  var Q = nextInt()
  var U = newSeqWith(Q, 0)
  var K = newSeqWith(Q, 0)
  for i in 0..<Q:
    U[i] = nextInt()
    K[i] = nextInt()
  solve(N, A.pred, B.pred, Q, U.pred, K)
else:
  discard

