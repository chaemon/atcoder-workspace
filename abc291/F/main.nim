when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/graph/graph_template, lib/graph/dijkstra

solveProc solve(N:int, M:int, S:seq[string]):
  var g, h = initGraph[int](N)
  for u in N:
    for i in M:
      if S[u][i] == '0': continue
      let v = u + i + 1
      # u -> vに移動可能
      g.addEdge(u, v)
      h.addEdge(v, u)
  var
    dist_g = g.dijkstra01(0)
    dist_h = h.dijkstra01(N - 1)
  var ans = Seq[int]
  for k in 1 .. N - 2:
    d := int.inf
    for u in k - M + 1 ..< k:
      if u < 0: continue
      if dist_g[u] == int.inf: continue
      for i in M:
        if S[u][i] == '0': continue
        let v = u + i + 1
        if v > N - 1: break
        if v <= k: continue
        if dist_h[v] == int.inf: continue
        doAssert u in 0 ..< N
        doAssert v in 0 ..< N
        doAssert u < k and k < v
        d.min= dist_g[u] + dist_h[v] + 1
    if d == int.inf:
      ans.add -1
    else:
      ans.add d
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, M, S)
else:
  discard

