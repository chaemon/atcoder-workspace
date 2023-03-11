include atcoder/extra/header/chaemon_header

import lib/graph/graph_template
import lib/graph/dijkstra

const DEBUG = true


proc solve(R:int, C:int, A:seq[seq[int]], B:seq[seq[int]]) =
  id(a:(int, int, int)) => (a[0] * C + a[1]) * 2 + a[2]
  var g = initGraph(R * C * 2, id, int)
  for r in R:
    for c in C:
      if c + 1 < C:
        g.addEdge((r, c, 0), (r, c + 1, 0), A[r][c])
      if c - 1 >= 0:
        g.addEdge((r, c, 0), (r, c - 1, 0), A[r][c - 1])
      if r + 1 < R:
        g.addEdge((r, c, 0), (r + 1, c, 0), B[r][c])
      g.addEdge((r, c, 0), (r, c, 1), 1)
      g.addEdge((r, c, 1), (r, c, 0), 0)
      if r - 1 >= 0:
        g.addEdge((r, c, 1), (r - 1, c, 1), 1)
  dist := g.dijkstra((0, 0, 0))
  echo dist[(R - 1, C - 1, 0)]
  return

# input part {{{
block:
  var R = nextInt()
  var C = nextInt()
  var A = newSeqWith(R, newSeqWith(C-1, nextInt()))
  var B = newSeqWith(R-1, newSeqWith(C, nextInt()))
  solve(R, C, A, B)
#}}}
