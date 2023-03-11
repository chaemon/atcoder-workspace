when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/tree/centroid_decomposition

solveProc solve(N:int, A:seq[int], B:seq[int]):
  Pred A, B
  var g = initUndirectedGraph(N, A, B)
  let (r, t) = g.centroidDecomposition(0)
  var ans = Seq[N: -1]
  for u in N:
    for e in t[u]:
      ans[e.dst] = e.src + 1
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

