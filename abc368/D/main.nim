when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, K:int, A:seq[int], B:seq[int], V:seq[int]):
  Pred V, A, B
  var
    g = initGraph[int](N)
    ans = 1
    is_V = Seq[N: false]
  for i in V.len:
    is_V[V[i]] = true
  for i in A.len:
    g.addBiEdge(A[i], B[i])
  proc dfs(u, p:int):int = # Vの頂点数
    result = 0
    if is_V[u]: result.inc
    for e in g[u]:
      if e.dst == p: continue
      var r = dfs(e.dst, u)
      if r > 0: ans.inc
      result += r
  discard dfs(V[0], -1)
  echo ans
  doAssert false

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
  var V = newSeqWith(K, nextInt())
  solve(N, K, A, B, V)
else:
  discard

