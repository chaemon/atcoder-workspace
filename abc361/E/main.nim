when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/tree/tree_diameter

solveProc solve(N:int, A:seq[int], B:seq[int], C:seq[int]):
  Pred A, B
  var g = initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(A[i], B[i], C[i])
  let d = g.treeDiameter().len
  echo C.sum * 2 - d
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  var C = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, A, B, C)
else:
  discard

