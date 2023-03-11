const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(a:int, N:int):
  var g = initGraph[int](10^6)
  for x in 1..10^6:
    block:
      let m = x * a
      if m < 10^6:
        g.addEdge(x, m)
    block:
      if x mod 10 != 0:
        var x2 = x
        var v = newSeq[int]()
        while x2 > 0:
          v.add x2 mod 10
          x2.div=10
        v = v[1..<v.len] & v[0]
        var p = 1
        var y = 0
        for i in v.len:
          y += p * v[i]
          p *= 10
        g.addEdge(x, y)
  var dist = g.dijkstra01(1)
  let d = dist[N]
  if d == int.inf:
    echo -1
  else:
    echo d
  discard

when not DO_TEST:
  var a = nextInt()
  var N = nextInt()
  solve(a, N)
else:
  discard

