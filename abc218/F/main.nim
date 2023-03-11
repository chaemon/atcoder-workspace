const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N:int, M:int, s:seq[int], t:seq[int]):
  var g = initGraph(N)
  for i in M:
    g.addEdge(s[i], t[i])
  var d = g.dijkstra01(0)
  let p = d.path(N - 1)
  var st = initSet[(int, int)]()
  for i in p.len - 1:
    st.incl((p[i], p[i + 1]))
  for i in M:
    var d0:int
    if (s[i], t[i]) notin st:
      d0 = d[N - 1]
    else:
      var g = initGraph(N)
      for j in M:
        if i == j: continue
        g.addEdge(s[j], t[j])
      d0 = g.dijkstra01(0)[N - 1]
    if d0 == int.inf: d0 = -1
    echo d0
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var s = newSeqWith(M, 0)
  var t = newSeqWith(M, 0)
  for i in 0..<M:
    s[i] = nextInt() - 1
    t[i] = nextInt() - 1
  solve(N, M, s, t)
else:
  discard

