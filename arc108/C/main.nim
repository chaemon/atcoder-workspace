include atcoder/extra/header/chaemon_header

import atcoder/dsu
import atcoder/extra/graph/graph_template

proc solve(N:int, M:int, u:seq[int], v:seq[int], c:seq[int]) =
  let N = N
  var uf = initDSU(N)
  var g = initGraph[int](N)

  for i in 0..<M:
    if uf.leader(u[i]) != uf.leader(v[i]):
      g.addBiEdge(u[i], v[i], c[i])
      uf.merge(u[i], v[i])
  if uf.groups.len != 1:
    echo -1;return

  var ans = newSeq[int](N)

  proc dfs[T](g:Graph[T], u:int, p:int, w:int, cu:int) =
    if cu != w:
      ans[u] = w
    else:
      var w2 = w + 1
      if w2 > N: w2 = 1
      # any number but w
      ans[u] = w2
    for e in g[u]:
      if e.dst == p: continue
      g.dfs(e.dst, u, e.weight, ans[u])
  
  g.dfs(0, -1, 1, -1)
  for i in 0..<N:
    echo ans[i]
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
    c[i] = nextInt()
  solve(N, M, u, v, c)
#}}}
