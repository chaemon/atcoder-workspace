const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/graph/graph_template

solveProc solve(N:int, A:seq[int], B:seq[int]):
  Pred A, B
  g := initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(A[i], B[i])
  var ans = Seq[2: seq[int]]
  proc dfs(u, c, p:int) =
    ans[c].add u
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, 1 - c, u)
  dfs(0, 0, -1)
  if ans[0].len < ans[1].len:
    swap ans[0], ans[1]
  var a = ans[0][0 ..< N div 2].succ
  echo a.join(" ")
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
