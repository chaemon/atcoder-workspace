const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

import lib/graph/graph_template

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  Pred A, B
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(A[i], B[i])
  var
    vis = Seq[N: -1]
    ok = true
  proc dfs(u, p, c:int) =
    if not ok: return
    if vis[u] != -1:
      if vis[u] != c:
        ok = false
      return
    vis[u] = c
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u, 1 - c)
  for u in N:
    if vis[u] == -1:
      dfs(u, -1, 0)
  if ok:
    echo YES
  else:
    echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

