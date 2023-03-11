include atcoder/extra/header/chaemon_header

var N:int
var M:int
var S:seq[string]

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  S = newSeqWith(N, nextString())
#}}}

import atcoder/mincostflow

const dir = [[0, 1], [1, 0]]

proc id(i, j:int):int = i * M + j

proc main() =
  let BIG = 1000000000
  let
    s = N * M
    t = s + 1
  var mcf_graph = initMCFGraph[int,int](N * M + 2)
  var num = 0
  for s in S:
    num += s.count('o')
  mcf_graph.add_edge(s, t, num, BIG)
  for i in 0..<N:
    for j in 0..<M:
      for d in 0..<2:
        if S[i][j] == '#': continue
        let
          i2 = i + dir[d][0]
          j2 = j + dir[d][1]
        if i2 notin 0..<N or j2 notin 0..<M: continue
        if S[i2][j2] == '#': continue
        mcf_graph.add_edge(id(i, j), id(i2, j2), 100, 0)
  for i in 0..<N:
    for j in 0..<M:
      if S[i][j] == 'o':
        mcf_graph.add_edge(s, id(i, j), 1, i + j)
      if S[i][j] == '.':
        mcf_graph.add_edge(id(i, j), t, 1, BIG - (i + j))
  let r = mcf_graph.flow(s, t, num)
  echo BIG * num - r[1]
  return

main()

