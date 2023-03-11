when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, M:int, u:seq[int], v:seq[int]):
  Pred u, v
  g := initDirectedGraph(N, u, v)
  ans := 0
  for u in N:
    vis := Seq[N: false]
    proc dfs(u, p:int) =
      if vis[u]: return
      vis[u] = true
      for e in g[u]:
        dfs(e.dst, u)
    dfs(u, -1)
    ans += vis.count(true) - 1
  echo ans - M
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, u, v)
else:
  discard

