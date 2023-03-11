include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/tree/tree_diameter

const DEBUG = true


proc solve(N:int, A:seq[int], B:seq[int]) =
  g := initGraph[int](N)
  for i in 0..<N-1: g.addBiEdge(A[i], B[i])
  let (d, a) = g.treeDiameter()
  var next = Seq[N: -1]
  for i in 0..<a.len - 1:
    next[a[i]] = a[i + 1]
  for u in 0..<N:
    if next[u] == -1: continue
    var next_index = -1
    for i, e in g[u]:
      if e.dst == next[u]: next_index = i
    swap(g[u][next_index], g[u][g[u].len - 1])
  var e = 1
  E := Seq[N: int]
  proc dfs(u, p:int) =
    E[u] = e
    for edge in g[u]:
      if edge.dst == p: continue
      e.inc
      dfs(edge.dst, u)
      e.inc
  dfs(a[0], -1)
  echo E.join(" ")
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, A, B)
#}}}

