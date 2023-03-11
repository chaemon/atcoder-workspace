include atcoder/extra/header/chaemon_header

import atcoder/segtree
import atcoder/extra/graph/graph_template

op(a, b:int) => a + b
e() => 0

const DEBUG = true

proc solve(N:int, P:seq[int], Q:int, U:seq[int], D:seq[int]) =
  var g = initGraph(N)
  for i in 0..<P.len:
    g.addBiEdge(i + 1, P[i])
  var q = Seq[N:seq[tuple[U, D, i:int]]]
  for i in Q: q[D[i]].add((U[i], D[i], i))
  var ans0 = Seq[Q:int]
  var rs = Seq[N:tuple[l, r:int]]
  var hs = Seq[N:seq[int]]
  proc dfs(u:int, l: var int, p = -1, h = 0) =
    let left = l
    hs[h].add(u)
    l.inc
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, l, u, h + 1)
    let right = l
    rs[u] = (left, right)
  var l = 0
  dfs(0, l)
  var st = initSegTree(l, op, e)
  for h in 0..<N:
    for u in hs[h]:
      let t = st[rs[u].l]
      st[rs[u].l] = t + 1
    for (U, D, i) in q[h]:
      let (l, r) = rs[U]
      ans0[i] = st[l..<r]
    for u in hs[h]: st[rs[u].l] = 0
  for a in ans0:
    echo a
  return

# input part {{{
block:
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt() - 1)
  var Q = nextInt()
  var U = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    U[i] = nextInt() - 1
    D[i] = nextInt()
  solve(N, P, Q, U, D)
#}}}

