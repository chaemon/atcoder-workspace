const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/graph/graph_template

const B = 450

type P = tuple[t, c:int]

solveProc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, x:seq[int], y:seq[int]):
  g := initGraph[int](N)
  col := Seq[N: P]
  for i in M:
    g.addBiEdge(a[i], b[i])
  selected := Seq[P]
  adj_list := Seq[seq[bool]]

  static:
    doAssert declaredInScope(B)
  id := initTable[int, int]()
  for u in N:
    col[u] = (-1, 1)
    if g[u].len >= B:
      id[u] = selected.len
      selected.add (-1, 1)
      adj_list.add Seq[N: false]
      adj_list[^1][u] = true
      for e in g[u]:
        adj_list[^1][e.dst] = true
  for t in Q:
    # x[t]をy[t]にする
    # x[t]の色を取得
    var c = col[x[t]]
    for i in selected.len:
      if adj_list[i][x[t]]:
        c.max=selected[i]
    col[x[t]] = c
    echo c.c
    col[x[t]] = (t, y[t])
    if x[t] in id:
      let i = id[x[t]]
      selected[i] = (t, y[t])
    else:
      for e in g[x[t]]:
        col[e.dst] = (t, y[t])
  return

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
  var y = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, M, a.pred, b.pred, Q, x.pred, y)
