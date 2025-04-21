when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/graph/graph_template

solveProc solve(N:int, u:seq[int], v:seq[int]):
  Pred u, v
  var g = initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(u[i], v[i])
  var
    ans = 0
    two_ct = 0
    vis = Seq[N: false]
  proc dfs(u, p:int) =
    vis[u] = true
    if g[u].len != 3:
      if g[u].len == 2: two_ct.inc
      return
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
  for u in N:
    if not vis[u] and g[u].len == 3:
      two_ct = 0
      dfs(u, -1)
      ans += (two_ct * (two_ct - 1)) div 2
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, u, v)
else:
  discard

