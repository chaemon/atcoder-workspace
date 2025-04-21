when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/scc, lib/graph/hopcroft_karp

solveProc solve(N:int, S:seq[string]):
  var id = initTable[string, int]()
  for i in N:
    id[S[i]] = i
  var
    g = initSCCGraph(N)
    edges = Seq[(int, int)]
  for i in N:
    let u = id[S[i]]
    for c in 'A' .. 'Z':
      let t = S[i][1] & c
      if t in id:
        let v = id[t]
        edges.add (u, v)
        g.addEdge u, v
  var
    s = g.scc()
    belongs = Seq[N: int]
  for i, v in s:
    for u in v:
      belongs[u] = i
  debug s, belongs
  var g2 = initHopcroftKarp(s.len, s.len)
  for (u, v) in edges:
    let
      ui = belongs[u]
      vi = belongs[v]
    if ui != vi:
      g2.addEdge(ui, vi)
  echo s.len - g2.maximum_matching().len

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

