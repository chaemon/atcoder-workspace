const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/other/binary_search
import std/heapqueue

solveProc solve(N:int, M:int, A:seq[int], U:seq[int], V:seq[int]):
  s := Seq[N: 0]
  g := initGraph[int](N)
  for i in M:
    g.addBiEdge(U[i], V[i])
    s[U[i]] += A[V[i]]
    s[V[i]] += A[U[i]]

  proc f(MX:int):bool =
    var s = s
    erased := Seq[N: false]
    var q = initHeapQueue[tuple[s, i: int]]()
    for i in N:
      q.push((s[i], i))
    while q.len > 0:
      var (si, i) = q.pop()
      if erased[i]: continue
      erased[i] = true
      if s[i] > MX: break
      for e in g[i]:
        if erased[e.dst]: continue
        s[e.dst] -= A[i]
        q.push (s[e.dst], e.dst)
    for u in N:
      if not erased[u]: return false
    return true
  echo f.minLeft(0 .. 2*10^9)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, M, A, U.pred, V.pred)
else:
  discard

