when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/maxflow
import lib/other/binary_search

solveProc solve(N:int, M:int, K:int, u:seq[int], v:seq[int]):
  Pred u, v
  proc f(d:int):bool =
    var
      g = initMFGraph[int](N * d + 2)
    let
      s = N * d
      t = s + 1
      INF = 10^5
    proc id(u, t:int):int =
      u * d + t
    g.addEdge(s, id(0, 0), INF)
    g.addEdge(id(N - 1, d - 1), t, INF)
    for u in N:
      for i in d - 1:
        g.addEdge(id(u, i), id(u, i + 1), INF)
    for i in M:
      let (u, v) = (u[i], v[i])
      for i in d:
        g.addEdge(id(u, i), id(v, i), 1)
      for i in d - 1:
        g.addEdge(id(u, i), id(v, i + 1), INF)
    return g.flow(s, t) <= K
  echo f.maxRight(1 .. N - 1)

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, K, u, v)
else:
  discard

