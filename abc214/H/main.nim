const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import atcoder/scc, atcoder/extra/graph/mincostflow_generalized
import lib/dp/cumulative_sum


solveProc solve(N:int, M:int, K:int, A:seq[int], B:seq[int], X:seq[int]):
  var g = initSccGraph(N)
  for i in M:
    g.addEdge(A[i], B[i])
  var a = g.scc
  var belongs = Seq[N: int]
  var x = Seq[a.len: 0]
  var start: int
  for i,a in a:
    for u in a:
      x[i] += X[u]
      belongs[u] = i
      if u == 0: start = i
  var mcf = initMCFGraph[int, int, GRAPHTYPE_DAG](a.len * 2 + 3)
  let
    s = a.len * 2
    t = s + 1
  mcf.addEdge(s, start * 2, K, 0)
  var v = Seq[int]
  for u in a.len:
    # u * 2 -> u * 2 + 1   cap: 1, cost: -x[u]
    mcf.addEdge(u * 2, u * 2 + 1, 1, -x[u])
    mcf.addEdge(u * 2, u * 2 + 1, K - 1, 0)
    mcf.addEdge(u * 2 + 1, t, K, 0)
  for i in M:
    let
      a = belongs[A[i]]
      b = belongs[B[i]]
    if a == b: continue
    mcf.addEdge(a * 2 + 1, b * 2, K, 0)
  let r = mcf.flow(s, t, K)
  echo -r.cost
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt().pred
    B[i] = nextInt().pred
  var X = newSeqWith(N, nextInt())
  solve(N, M, K, A, B, X)

