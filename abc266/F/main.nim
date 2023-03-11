const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/cycle_detection
import atcoder/dsu

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, u:seq[int], v:seq[int], Q:int, x:seq[int], y:seq[int]):
  g := initGraph[int](N)
  for i in N: g.addBiEdge(u[i], v[i])
  var c = g.cycleDetectionUndirected
  d := initDSU(N)
  var cycle = initSet[(int, int)]()
  for e in c.get:
    cycle.incl (e.src, e.dst)
    cycle.incl (e.dst, e.src)
  for i in N:
    if (u[i], v[i]) in cycle: continue
    d.merge(u[i], v[i])
  for q in Q:
    if d.same(x[q], y[q]): echo YES
    else:
      echo NO

when not defined(DO_TEST):
  var N = nextInt()
  var u = newSeqWith(N, 0)
  var v = newSeqWith(N, 0)
  for i in 0..<N:
    u[i] = nextInt()
    v[i] = nextInt()
  var Q = nextInt()
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, u.pred, v.pred, Q, x.pred, y.pred)
else:
  discard

