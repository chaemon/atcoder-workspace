const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/tree/tree_diameter

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, U:seq[int], V:seq[int]):
  var g = initGraph[int](N)
  for i in N - 1:
    g.addBiEdge(U[i], V[i])
  let (d, vs) = g.tree_diameter
  let r = d div 2
  var c = vs.centroid
  var size = Seq[N: int]
  proc dfs(u, p:int, h = 0) =
    if h == r:
      size[u].inc
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u, h + 1)
      size[u] += size[e.dst]
  var v = Seq[mint]
  if c.len == 1:
    for e in g[c[0]]:
      dfs(e.dst, c[0], 1)
      v.add size[e.dst]
  elif c.len == 2:
    dfs(c[0], c[1])
    v.add size[c[0]]
    dfs(c[1], c[0])
    v.add size[c[1]]
  else:
    doAssert false
  var ans = mint(1)
  for v in v: ans *= v + 1
  ans -= v.sum
  ans -= 1
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var U = newSeqWith(N-1, 0)
  var V = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  solve(N, U, V)
else:
  discard

