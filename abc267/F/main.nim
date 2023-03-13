const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/tree/tree_diameter
import lib/tree/doubling_lowest_common_ancestor

solveProc solve(N:int, A:seq[int], B:seq[int], Q:int, U:seq[int], K:seq[int]):
  Pred A, B, U
  g := initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(A[i], B[i])
  var
    (l, path) = g.treeDiameter()
    pos = Seq[N: -1]
  for i in path.len:
    pos[path[i]] = i
  # N + 1を根とするグラフを再構築
  # パス上のものはすべてN + 1
  g2 := initGraph[int](N + 1)
  for i in N - 1:
    if pos[A[i]] >= 0 and pos[B[i]] >= 0:
      continue
    g2.addBiEdge A[i], B[i]
  for u in path:
    g2.addBiEdge u, N
  var
    lca = initDoublingLowestCommonAncestor(g2, N)
    ans = Seq[int]
  for q in Q:
    var (U, K) = (U[q], K[q])
    found := false
    if pos[U] == -1:
      let d = lca.dep[U]
      if d > K:
        ans.add lca.ancestor(U, d - K)
        found = true
      else:
        U = lca.ancestor(U, 1)
        K -= d - 1
    if not found:
      # 左にK個または右にK個
      let p = pos[U]
      doAssert 0 <= p
      if p - K >= 0:
        ans.add path[p - K]
      elif p + K < path.len:
        ans.add path[p + K]
      else:
        ans.add -1
  for u in ans.mitems:
    if u >= 0: u.inc
  echo ans.join("\n")
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
  solve(N, A, B, Q, U, K)
else:
  discard

