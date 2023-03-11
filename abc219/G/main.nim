const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template

const B = 450
 
type P = tuple[t, c:int]
 
solveProc solve(N:int, M:int, Q:int, u:seq[int], v:seq[int], x:seq[int]):
#solveProc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, x:seq[int], y:seq[int]):
  g := initGraph[int](N)
  col := Seq[N: P]
  for i in M:
    g.addBiEdge(u[i], v[i])
  selected := Seq[P]
  adj_list := Seq[seq[bool]]
 
  static:
    doAssert declaredInScope(B)
  id := initTable[int, int]()
  for u in N:
    col[u] = (-1, u + 1)
    if g[u].len >= B:
      id[u] = selected.len
      selected.add (-1, 1)
      adj_list.add Seq[N: false]
      adj_list[^1][u] = true
      for e in g[u]:
        adj_list[^1][e.dst] = true
  proc get_color(u: int):int =
    var c = col[u]
    for i in selected.len:
      if adj_list[i][u]:
        c.max=selected[i]
    col[u] = c
    return c.c

  for t in Q:
    # x[t]をy[t]にする
    # x[t]の色を取得
    let c = get_color(x[t])
    #echo c.c
    #col[x[t]] = (t, y[t])
    if x[t] in id:
      let i = id[x[t]]
      selected[i] = (t, c)
    else:
      for e in g[x[t]]:
        col[e.dst] = (t, c)
  var ans = collect(newSeq):
    for u in N:
      get_color(u)
  echo ans.join(" ")
  return


when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  var x = newSeqWith(Q, nextInt())
  solve(N, M, Q, u.pred, v.pred, x.pred)
else:
  discard

