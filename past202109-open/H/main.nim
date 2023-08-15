when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, X:int, a:seq[int], b:seq[int], c:seq[int]):
  Pred a, b
  var g = initGraph[int](N)
  for i in a.len:
    g.addBiEdge a[i], b[i], c[i]
  for u in N:
    var dist = g.dijkstra(u)
    for v in N:
      if dist[v] == X:
        echo YES;return
  echo NO;return

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  var c = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
  solve(N, X, a, b, c)
else:
  discard

