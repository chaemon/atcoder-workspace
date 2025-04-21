when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils, lib/graph/graph_template
import std/heapqueue

solveProc solve(N:int, M:int, K:int, A:seq[int], B:seq[int], C:seq[int]):
  Pred A, B, K
  g := initGraph[int](N)
  for i in M:
    g.addBiEdge(A[i], B[i], C[i])
  var dp = Seq[2^K, N: int.inf] # dp[b][u]: bとuをつなぐコスト
  for u in K:
    dp[1 shl u][u] = 0
  for b in 1 ..< 2^K:
    # bの部分集合について
    for u in N:
      for b2 in b.subsets:
        if b2 == 0 or b == b2: continue
        dp[b][u].min=dp[b2][u] + dp[b xor b2][u]
    # dp[b][u]を辺で確定(小さい順)
    var
      q = initHeapQueue[tuple[d, u:int]]()
      vis = Seq[N: false]
    for u in N:
      q.push (dp[b][u], u)
    while q.len > 0:
      let (d, u) = q.pop()
      if vis[u]: continue
      vis[u] = true
      for e in g[u]:
        let
          v = e.dst
          d2 = dp[b][u] + e.weight
        if d2 < dp[b][v]:
          dp[b][v] = d2
          q.push (d2, v)
  for u in K ..< N:
    echo dp[2^K - 1][u]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, K, A, B, C)
else:
  discard

