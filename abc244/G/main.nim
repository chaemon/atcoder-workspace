const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, M:int, u:seq[int], v:seq[int], S:string):
  var P = Seq[N: 0]
  for i in N:
    if S[i] == '1': P[i] = 1
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(u[i], v[i])
  var
    ans = newSeq[int]()
    vis = newSeq[int](N)
  proc dfs(u, p:int) =
    assert vis[u] == 0
    ans.add u
    vis[u].inc
    for e in g[u]:
      if e.dst == p or vis[e.dst] > 0: continue
      dfs(e.dst, u)
      ans.add u
      vis[u].inc
      if vis[e.dst] mod 2 != P[e.dst]:
        ans.add e.dst
        vis[e.dst].inc
        ans.add u
        vis[u].inc
  dfs(0, -1)
  if vis[0] mod 2 != P[0]:
    discard ans.pop
  for a in ans.mitems: a.inc
  echo ans.len
  echo ans.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  var S = nextString()
  solve(N, M, u, v, S)
else:
  discard

