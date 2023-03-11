include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

proc solve(a:int, b:int, x:int, y:int) =
  proc id(x, y:int):int =
    if y == 0:
      return x
    else:
      return 100 + x
  var g = initGraph[int](200)
  for i in 0..<100:
    g.addBiEdge(id(i, 0), id(i, 1), x)
    if i < 100 - 1:
      g.addBiEdge(id(i + 1, 0), id(i, 1), x)
      g.addBiEdge(id(i, 0), id(i + 1, 0), y)
      g.addBiEdge(id(i, 1), id(i + 1, 1), y)
  let (dist, _) = g.dijkstra(id(a, 0))
  echo dist[id(b, 1)]
  return

# input part {{{
block:
  var a = nextInt() - 1
  var b = nextInt() - 1
  var x = nextInt()
  var y = nextInt()
  solve(a, b, x, y)
#}}}
