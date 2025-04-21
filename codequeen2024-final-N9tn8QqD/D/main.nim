when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/graph/dijkstra
import std/heapqueue

solveProc solve(N: int, M: int, K: int, a: seq[int], b: seq[int], d: seq[int],
  c: seq[int], t: seq[int]):

  Pred a, b, c
  var
    g = initGraph[int](N)
    q = Seq[N: initHeapQueue[tuple[t, n: int]]()]
    event = Seq[tuple[t, u: int]]
  for i in M:
    g.addBiEdge(a[i], b[i], d[i])
  for i in K:
    event.add (t[i], c[i])
  event.sort
  var
    d = g.dijkstra(0)
    ans = 0
  for u in N:
    if d[u].isInf: continue
    q[u].push (d[u], 0)
  for (t, c) in event:
    var
      e = 0
      found = false
    # 地点cに時刻tより前に辿り着けるものを探す
    while q[c].len > 0 and q[c][0].t <= t:
      let (t, n) = q[c].pop
      found = true
      e.max = n
    if not found: continue
    e.inc
    # cからダイクストラ
    var d = g.dijkstra(c)
    for u in N:
      if d[u].isInf: continue
      q[u].push (t + d[u], e)
    ans.max = e
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  var d = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
    d[i] = nextInt()
  var c = newSeqWith(K, 0)
  var t = newSeqWith(K, 0)
  for i in 0..<K:
    c[i] = nextInt()
    t[i] = nextInt()
  solve(N, M, K, a, b, d, c, t)
else:
  discard

