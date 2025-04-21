when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template, lib/graph/dijkstra

solveProc solve(N:int, C:seq[string]):
  var
    g = initGraph[int](N * N + 1)
    s = N * N + 1
  proc id_node(i, j:int):int = i * N + j
  for i in N:
    for j in N:
      for i1 in N:
        if C[i1][i] == '-': continue
        for j1 in N:
          if C[j][j1] == '-' or C[i1][i] != C[j][j1]: continue
          g.addEdge(id_node(i, j), id_node(i1, j1), 1)
  for i in N:
    g.addEdge(s, id_node(i, i), 0)
    for j in N:
      if C[i][j] == '-': continue
      g.addEdge(s, id_node(i, j), 1)
  var
    d = g.dijkstra01(s)
    ans = Seq[N, N: int]
  for i in N:
    for j in N:
      let d = d[id_node(i, j)]
      if d.isInf: ans[i][j] = -1
      else: ans[i][j] = d
  for i in N:
    echo ans[i].join(" ")

when not defined(DO_TEST):
  var N = nextInt()
  var C = newSeqWith(N, nextString())
  solve(N, C)
else:
  discard

