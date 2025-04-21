when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template
import lib/other/bitutils

solveProc solve(N:int, M:int, X:seq[int], Y:seq[int], Z:seq[int]):
  Pred X, Y
  var g = initGraph[int](N)
  for i in M:
    g.addBiEdge(X[i], Y[i], Z[i])
  const D = 30
  var
    a = Array[D: int]
    val = Seq[N: Array[D: int8(-1)]]
    A = Seq[N: 0]
    vis = Seq[N: false]
    ok = true
    ct = Seq[D: 0]
    visited: seq[int]
  proc dfs(u, p, c:int):int =
    if vis[u]:
      for i in D:
        if val[u][i] != -1 and c[i] != val[u][i]:
          ok = false
        val[u][i] = int8(c[i])
    else:
      vis[u] = true
      A[u] = c
      result = 1
      visited.add u
      for i in D:
        if c[i] == 1: ct[i].inc
        val[u][i] = int8(c[i])
      for e in g[u]:
        if e.dst == p: continue
        result += dfs(e.dst, u, c xor e.weight)
        if not ok: return
  for u in N:
    if vis[u]: continue
    ct = Seq[D: 0]
    visited.setLen(0)
    let s = dfs(u, -1, 0)
    if not ok:
      echo -1;return
    var flip = 0
    for i in D:
      if ct[i] > s - ct[i]:
        flip[i] = 1
    for u in visited:
      A[u] = A[u] xor flip
  echo A.join(" ")
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  var Z = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
    Z[i] = nextInt()
  solve(N, M, X, Y, Z)
else:
  discard

