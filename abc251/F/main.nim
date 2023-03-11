const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template


solveProc solve(N:int, M:int, u:seq[int], v:seq[int]):
  g := initGraph[int](N)
  for i in M:
    g.addBiEdge(u[i], v[i])
  block:
    vis := Seq[N: false]
    proc dfs(u, p:int) =
      doAssert not vis[u]
      vis[u] = true
      if p != -1:
        echo p + 1, " ", u + 1
      for e in g[u]:
        if e.dst == p or vis[e.dst]: continue
        dfs(e.dst, u)
    dfs(0, -1)
  block:
    var q = initDeque[(int, int)]()
    q.addLast (-1, 0)
    vis := Seq[N: false]
    while q.len > 0:
      var (p, u) = q.popFirst
      if vis[u]: continue
      vis[u] = true
      if p != -1:
        echo p + 1, " ", u + 1
      for e in g[u]:
        if e.dst == p or vis[e.dst]: continue
        q.addLast (u, e.dst)
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  solve(N, M, u, v)
else:
  discard

