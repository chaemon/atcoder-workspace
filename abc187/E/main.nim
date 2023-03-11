include atcoder/extra/header/chaemon_header
import atcoder/extra/graph/graph_template

proc solve(N:int, a:seq[int], b:seq[int], Q:int, t:seq[int], e:seq[int], x:seq[int]) =
  var g = initGraph[int](N)
  for i in 0..<N-1:
    g.addBiEdge(a[i], b[i], i)
  var par = newSeq[int](N)
  proc dfs(u:int, p = -1) =
    par[u] = p
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
  dfs(0)
  var s = 0
  var ans = newSeq[int](N)
  for i in 0..<Q:
    var u:int
    var parent = false
    if t[i] == 1:
      if par[a[e[i]]] == b[e[i]]:
        u = a[e[i]]
      else:
        u = b[e[i]]
        parent = true
    else:
      if par[b[e[i]]] == a[e[i]]:
        u = b[e[i]]
      else:
        u = a[e[i]]
        parent = true
    if parent:
      s += x[i]
      ans[u] -= x[i]
    else:
      ans[u] += x[i]
  proc dfs2(u:int, c = 0, p = -1) =
    var c = c + ans[u]
    for e in g[u]:
      if e.dst == p: continue
      dfs2(e.dst, c, u)
    ans[u] = c
  dfs2(0)
  for u in 0..<N:
    echo ans[u] + s
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var e = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    e[i] = nextInt() - 1
    x[i] = nextInt()
  solve(N, a, b, Q, t, e, x)
#}}}
