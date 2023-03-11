const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/tree/rerooting

type Data = tuple[n, s:int]
type Weight = int

f_up(d:Data, w:Weight)=>(d.n + 1, d.s + d.n + 1)
f_merge(d0, d1:Data)=>(d0.n + d1.n, d0.s + d1.s)

solveProc solve(N:int, u:seq[int], v:seq[int]):
  var g = initReRooting(N, f_up, f_merge, (0, 0))
  for i in N - 1: g.addBiEdge(u[i], v[i], 1, 1)
  var v = g.solve()
  for v in v:
    echo v.s
  return

when not DO_TEST:
  var N = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt() - 1
    v[i] = nextInt() - 1
  solve(N, u, v)
else:
  discard

