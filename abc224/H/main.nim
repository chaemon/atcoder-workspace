const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/extra/graph/mincostflow_generalized

const T = 10

solveProc solve(L:int, R:int, A:seq[int], B:seq[int], C:seq[seq[int]]):
  var g = initMinCostFlow[int, int, GRAPHTYPE_GENERAL](L + R + 2)
  let
    s = L + R
    t = s + 1
  for i in L:
    g.addEdge(s, i, A[i], 0)
  for j in R:
    g.addEdge(j + L, t, B[j], 0)
  for i in L:
    for j in R:
      g.addEdge(i, j + L, T, -C[i][j])
  echo -g.flow(s, t).cost
  return

when not DO_TEST:
  var L = nextInt()
  var R = nextInt()
  var A = newSeqWith(L, nextInt())
  var B = newSeqWith(R, nextInt())
  var C = newSeqWith(L, newSeqWith(R, nextInt()))
  solve(L, R, A, B, C)
else:
  discard

