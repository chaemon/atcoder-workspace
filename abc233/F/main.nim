const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu
import lib/graph/graph_template
import deques

solveProc solve(N:int, P:seq[int], M:int, a:seq[int], b:seq[int]):
  var
    dsu = initDSU(N)
    g = initGraph[int](N)
  for i in M:
    if dsu.leader(a[i]) == dsu.leader(b[i]): continue
    dsu.merge(a[i], b[i])
    g.addBiEdge(a[i], b[i], i + 1)
  var vis = Seq[N: false]
  var a = Seq[int]
  proc bfs(u:int) =
    var q = initDeque[(int, int)]()
    q.addLast((u, -1))
    while q.len > 0:
      let (u, p) = q.popFirst
      a.add u
      for e in g[u]:
        let v = e.dst
        if v == p: continue
        q.addLast((v, u))
    for u in a:
      vis[u] = true
  var P = P
  var ans = Seq[int]
  proc dfs(u, p, target:int):bool =
    if P[u] == target: return true
    for e in g[u]:
      let v = e.dst
      if v == p: continue
      if dfs(v, u, target):
        ans.add(e.weight)
        swap(P[u], P[v])
        return true
    return false
  for u in N:
    if vis[u]: continue
    a.setLen(0)
    bfs(u)
    a.reverse
    for u in a:
      if not dfs(u, -1, u):
        echo -1;return
  echo ans.len
  if ans.len > 0:
    echo ans.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, P, M, a, b)
else:
  discard

