const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/graph/graph_template
import lib/graph/dijkstra
import lib/other/compress

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var c = initCompress[int](B)
  var g = initGraph(N + c.len + 1)
  let s = N + c.len
  for u in N: g.addEdge(u, s, A[u])
  for u in N: g.addEdge(s, u, B[u])
  for i in c.len:
    let
      j = (i + 1) mod c.len
      d = (c[j] - c[i] + M) mod M
    g.addEdge(i + N, j + N, d)
  for u in N:
    # find smallest j such that A[u] + c[j] >= M
    let j = c.lowerBound(M - A[u])
    if j == c.len: continue
    g.addEdge(u, j + N, A[u] + c[j] - M)
  for u in N:
    let i = c{B[u]}
    g.addEdge(i + N, u, 0)
  var d = g.dijkstra(0)
  echo d[N - 1]
  Naive:
    var g = initGraph[int](N)
    for i in N:
      for j in N:
        g.addEdge(i, j, (A[i] + B[j]) mod M)
    var d = g.dijkstra(0)
    echo d[N - 1]
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, M, A, B)
else:
  import random
  const
    M = 2525
    N = 1000
  for _ in 10000:
    var A = Seq[N: random.rand(0..<M)]
    var B = Seq[N: random.rand(0..<M)]
    test(N, M, A, B)
