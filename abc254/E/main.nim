const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template

solveProc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, x:seq[int], k:seq[int]):
  var g = initGraph[int](N)
  for i in M: g.addBiEdge(a[i], b[i])
  var
    s = initSet[int]()
    k0:int
  proc dfs(u, p, h:int) =
    s.incl(u)
    if h == k0: return
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u, h + 1)
  for q in Q:
    let (x, k) = (x[q], k[q])
    k0 = k
    s.clear()
    dfs(x, -1, 0)
    ans := 0
    for s in s:
      ans += s + 1
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var x = newSeqWith(Q, 0)
  var k = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    k[i] = nextInt()
  solve(N, M, a.pred, b.pred, Q, x.pred, k)
else:
  discard

