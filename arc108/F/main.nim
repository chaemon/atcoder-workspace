include atcoder/extra/header/chaemon_header

#import atcoder/modint
import atcoder/extra/math/modint_montgomery
const MOD = 1000000007
type mint = modint1000000007

import atcoder/extra/graph/graph_template
import atcoder/extra/tree/tree_diameter

proc solve(N:int, a:seq[int], b:seq[int]) =
  var g = initGraph[int](N)
  for i in 0..<N-1: g.addBiEdge(a[i], b[i])
  let (dist_max, v) = g.treeDiameter()
  let (p, q) = (v[0], v[^1])
  proc dfs(u, p, d:int, dist:var seq[int]) =
    dist[u] = d
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u, d + 1, dist)
  var dist_p, dist_q = newSeq[int](N)
  dfs(p, -1, 0, dist_p)
  dfs(q, -1, 0, dist_q)
  var dist_min = -int.inf
  var w = newSeq[int]()
  for u in 0..<N:
    dist_min >?= min(dist_p[u], dist_q[u])
    w.add max(dist_p[u], dist_q[u])
  w.sort()
  w.reverse()
  var
    wi = 0
    t = N
    a = newSeq[mint]()
  for d in dist_min..dist_max << 1:
    a.add(mint(2)^t)
    if d < dist_max: a[^1] *= 2
    while wi < N and w[wi] >= d: t.dec;wi.inc
  a.add(0)
  var
    ans = mint(0)
    ai = 0
  for d in dist_min..dist_max << 1:
    ans += (a[ai] - a[ai + 1]) * d
    ai.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
#}}}
