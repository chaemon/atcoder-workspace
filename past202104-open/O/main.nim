when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include atcoder/extra/header/chaemon_header
import lib/graph/graph_template
import lib/tree/doubling_lowest_common_ancestor

proc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, u:seq[int], v:seq[int]) =
  Pred a, b, u, v
  var g, h = initGraph(N)
  for i in M:
    g.addBiEdge a[i], b[i], 1
  var
    vis = Seq[N: false]
    w:seq[int]
  proc dfs(u:int, p = -1) =
    vis[u] = true
    for e in g[u]:
      if vis[e.dst]:
        w.add u
        w.add e.dst
        continue
      h.addBiEdge(u, e.dst)
      dfs(e.dst, u)
  dfs(0)
  var dc = h.initDoublingLowestCommonAncestor(0)
  var dist = [w.len, w.len] @ 0
  for i in w.len:
    for j in w.len:
      dist[i][j] = dc.dist(w[i], w[j])
  let c = w.len div 2
  for q in Q:
    var dp = w.len @ int
    let (u, v) = (u[q], v[q])
    for i in w.len:
      dp[i] = dc.dist(u, w[i])
    for _ in c:
      block:
        var dp2 = dp
        for i in w.len:
          let i2 = if i mod 2 == 0: i + 1: else: i - 1
          dp2[i2].min=dp[i] + 1
        dp = dp2.move
      block:
        var dp2 = dp
        for i in w.len:
          for j in w.len:
            dp2[j].min=dp[i] + dist[i][j]
        dp = dp2.move
    ans := dc.dist(u, v)
    for i in w.len:
      ans.min=dp[i] + dc.dist(w[i], v)
    echo ans
  return

block:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var u = newSeqWith(Q, 0)
  var v = newSeqWith(Q, 0)
  for i in 0..<Q:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, a, b, Q, u, v)
