include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra
include atcoder/extra/other/bitutils

const DEBUG = false

proc solve() =
  let N, M = nextInt()
  var A, B = Seq(M, int)
  for i in M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  let K = nextInt()
  let C = Seq(K, nextInt() - 1)
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(A[i], B[i], 1)
  var dists = Seq(0, seq[int])
  for i in K:
    let (dist, _) = g.dijkstra(C[i])
    dists.add(dist)
  debug dists
  var dp = Seq(1 << K, K, int.inf)
  for p in K: dp[1 << p][p] = 1
  for b in 1 << K:
    if b.popcount <= 1: continue
    debug b
    for p in K:
      if not b[p]: continue
      for i in K:
        if p == i: continue
        if not b[i]: continue
        let d = dists[i][C[p]]
        if d == int.inf: continue
        dp[b][p].min=d + dp[b xor [p]][i]
    debug b, dp[b]
  var ans = int.inf
  for i in K:
    ans.min=dp[2^K - 1][i]
  if ans == int.inf:
    echo -1
  else:
    echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
