const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, a:seq[int], b:seq[int]):
  Pred a, b
  g := initUndirectedGraph[int](N, a, b)
  var
    sz = Seq[N: 0]
    ans = 0
  proc dfs(u, p:int) =
    sz[u] = 1
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
      sz[u] += sz[e.dst]
    ans += sz[u] * (N - sz[u])
  dfs(0, -1)
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, a, b)

