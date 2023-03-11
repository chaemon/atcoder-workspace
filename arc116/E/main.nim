include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/other/binary_search

const DEBUG = true

proc solve(N:int, K:int, u:seq[int], v:seq[int]) =
  g := initGraph[int](N)
  for i in 0..<N-1: g.addBiEdge(u[i], v[i])
  proc dfs(u, p, t:int):tuple[n, t:int] =
    result.n = 0
    result.t = int.inf # calc minimum
    var zero_far = 0
    var flag = false
    for e in g[u]:
      if e.dst == p: continue
      var (n0, t0) = dfs(e.dst, u, t)
      t0.inc
      result.n += n0
      if result.t + t0 >= 2 * t: flag = true
      if n0 == 0:
        zero_far.max=t0
      else:
        discard
    if result.n == 0:
      if zero_far == K: result.n = 1; result.t = 0
    else:
      discard

  proc f(t:int):bool =
    # (n, t) := dfs(0, -1)
    let (n, _) = dfs(0, -1, t)
    return n <= K
  echo f.minLeft(1..N)
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, K, u, v)
#}}}

