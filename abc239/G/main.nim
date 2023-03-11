const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/maxflow

solveProc solve(N:int, M:int, a:seq[int], b:seq[int], c:seq[int]):
  var g = initMaxFlow[int](N * 2 + 2)
  let
    s = N * 2
    t = s + 1
  g.addEdge(s, 1, int.inf)
  g.addEdge((N - 1) * 2, t, int.inf)
  var es = Seq[N: int]
  for u in N:
    es[u] = g.addEdge(u * 2, u * 2 + 1, c[u])
  for i in M:
    g.addEdge(a[i] * 2 + 1, b[i] * 2, int.inf)
    g.addEdge(b[i] * 2 + 1, a[i] * 2, int.inf)
  let C = g.flow(s, t)
  var
    v = g.min_cut(s)
    ans = Seq[int]
  for u in 1 .. N - 2:
    if v[u * 2] and not v[u * 2 + 1]:
      ans.add u
  echo C
  echo ans.len
  echo ans.succ.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var c = newSeqWith(N, nextInt())
  solve(N, M, a.pred, b.pred, c)
else:
  discard

