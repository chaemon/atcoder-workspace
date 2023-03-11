const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import atcoder/scc


solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var g = initSccGraph(N)
  for i in M:
    g.addEdge(A[i], B[i])
  ans := 0
  for a in g.scc():
    ans += (a.len * (a.len - 1)) div 2
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A.pred, B.pred)
