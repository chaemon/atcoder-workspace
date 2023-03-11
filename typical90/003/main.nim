const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/tree/tree_diameter

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var g = initGraph(N)
  for i in N - 1: g.addBiEdge(A[i], B[i])
  echo g.treeDiameter[0] + 1
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, A, B)
#}}}

