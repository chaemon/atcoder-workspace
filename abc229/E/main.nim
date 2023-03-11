const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import atcoder/dsu

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var uf = initDSU(N)
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(A[i], B[i])
  var k = 0
  var ans = Seq[int]
  for u in 0..<N << 1:
    ans.add(k)
    k.inc
    for e in g[u]:
      if u > e.dst: continue
      if uf.leader(u) != uf.leader(e.dst):
        k.dec
        uf.merge(u, e.dst)
  ans.reverse
  echo ans.join("\n")
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, M, A, B)
else:
  discard

