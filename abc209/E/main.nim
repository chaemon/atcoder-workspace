const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/graph/graph_template
import deques

proc id(a:char):int =
  if a in 'a'..'z':
    return a.ord - 'a'.ord
  elif a in 'A'..'Z':
    return a.ord - 'A'.ord + 26

proc id(s:string):int =
  result = 0
  for i in 0..<3:
    result *= 52
    result += id(s[i])

const B = 52^3
solveProc solve(N:int, s:seq[string]):
  type State = enum
    X="Draw"
    Next="Aoki"
    Prev="Takahashi"
  var vis = Seq[B:false]
  var g, h = initGraph[int](B)
  for i in N:
    let x = id(s[i][0..<3])
    let y = id(s[i][^3..^1])
    g.addEdge(x, y)
    h.addEdge(y, x)
  var q = initDeque[int]()
  var a = Seq[B:State.X]
  var nextCount = Seq[B:int] # 隣接のNextが何個あるか
  proc setPrev(u:int) =
    if vis[u]: return
    vis[u] = true
    a[u] = State.Prev
    # uに移動できる点をNextにする
    for e in h[u]:
      if vis[e.dst]: continue
      a[e.dst] = State.Next
      vis[e.dst] = true
      for f in h[e.dst]:
        nextCount[f.dst].inc
        q.addLast(f.dst)
  for u in B:
    if g[u].len == 0:
      setPrev(u)
  while q.len > 0:
    let u = q.popFirst
    # 隣接点が全部NextだったらPrev
    if nextCount[u] == g[u].len:
      setPrev(u)
  for i in N:
    let t = id(s[i][^3..^1])
    echo a[t]
  return

when not DO_TEST:
  var N = nextInt()
  var s = newSeqWith(N, nextString())
  solve(N, s)
else:
  discard

