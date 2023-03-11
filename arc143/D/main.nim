const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/graph/graph_template, lib/graph/ear_decomposition

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(A[i], B[i], i)
  var
    e = g.ear_decomposition
    ans = "0".repeat(M)
  for e in e:
    for e in e: # 連結成分ごと
      for (u, i) in e:
        let
          j = g[u][i].weight
          v = g[u][i].dst
        if u == B[j] and v == A[j]:
          ans[j] = '1'
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, nextInt() - 1)
  var B = newSeqWith(M, nextInt() - 1)
  solve(N, M, A, B)
else:
  var g = initGraph(4)
  g.addBiEdge(0, 1)
  g.addBiEdge(1, 2)
  g.addBiEdge(2, 3)
  g.addBiEdge(3, 0)
  g.addBiEdge(0, 0)

  echo g.ear_decomposition

