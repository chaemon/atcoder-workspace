include atcoder/extra/header/chaemon_header

import lib/graph/graph_template
import lib/graph/hopcroft_karp

const DEBUG = true

let H, W = nextInt()
let s = Seq[H: nextString()]

var hk = initHopcroftKarp(H, W)
for i in 0..<H:
  for j in 0..<W:
    if s[i][j] == 'R':
      hk.addEdge(i, j)

echo hk.maximum_matching()
echo hk.minimum_vertex_cover()
echo hk.maximum_stable_set()
