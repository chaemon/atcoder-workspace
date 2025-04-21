when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template, lib/tree/tree_diameter
import atcoder/convolution

# Failed to predict input format
solveProc solve():
  proc read():auto =
    let N = nextInt()
    var g = initGraph[int](N)
    for _ in N - 1:
      let u, v = nextInt() - 1
      g.addBiEdge(u, v)
    return (N, g)
  let (N1, g1) = read()
  let (N2, g2) = read()
  proc get_farthest_table(g:auto):tuple[d:int , a: seq[int]] =
    var (d, path) = g.treeDiameter()
    doAssert path.len == d + 1
    let h = d div 2
    var ans = Seq[g.len: 0]
    proc dfs(u, p:int, h = 0) =
      ans[u] = h
      for e in g[u]:
        if e.dst == p: continue
        dfs(e.dst, u, h + 1)
    if d mod 2 == 0:
      let s = path[d div 2]
      dfs(s, -1)
      for u in g.len:
        ans[u] += d div 2
    else:
      let
        s = path[d div 2]
        t = path[d div 2 + 1]
      dfs(s, t)
      dfs(t, s)
      for u in g.len:
        ans[u] += d div 2 + 1
    let M = ans.max
    var a = Seq[M + 1: 0]
    for x in ans:
      a[x].inc
    return (d, a)
  var
    (d1, a1) = get_farthest_table(g1)
    (d2, a2) = get_farthest_table(g2)
  let D = max(d1, d2)
  var
    u = @[0] & convolution_ll(a1, a2)
    ans = 0
  # D以下は全部D
  ans += u[0 .. D].sum * D
  for d in D + 1 ..< u.len:
    ans += u[d] * d
  echo ans

when not DO_TEST:
  solve()
else:
  discard

