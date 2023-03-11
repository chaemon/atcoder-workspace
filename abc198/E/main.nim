include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template

const DEBUG = true

proc solve(N:int, C:seq[int], A:seq[int], B:seq[int]) =
  var g = initGraph[int](N)
  for i in N - 1: g.addBiEdge(A[i], B[i])
  s := initTable[int, int]()
  ans := Seq[int]
  proc dfs(u, p:int) =
    let c = C[u]
    if c notin s: s[c] = 0
    s[c].inc
    if s[c] == 1: ans.add(u + 1)
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
    s[c].dec
  dfs(0, -1)
  ans.sort()
  echo ans.join("\n")
  return

# input part {{{
block:
  var N = nextInt()
  var C = newSeqWith(N, nextInt() - 1)
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, C, A, B)
#}}}

