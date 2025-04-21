when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra

solveProc solve(N:int, M:int, a:seq[int], b:seq[int]):
  Pred a, b
  var g = initGraph[int](N)
  for i in M:
    g.addEdge(a[i], b[i])
  var
    d = g.dijkstra(0)
    ans = int.inf
  for i in M:
    if b[i] == 0:
      ans.min=d[a[i]] + 1
  if ans.isInf:
    echo -1
  else:
    echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, M, a, b)
else:
  discard

