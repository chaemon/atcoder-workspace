const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/graph/graph_template
import lib/tree/doubling_lowest_common_ancestor

proc solve() =
  let N = nextInt()
  var (A, B) = unzip(N - 1, (nextInt() - 1, nextInt() - 1))
  var g = initGraph(N)
  for i in N - 1:
    g.addBiEdge(A[i], B[i])
  var
    id = Seq[N: int]
    c = 0
  proc dfs(u, p:int) =
    id[u] = c
    c.inc
    for e in g[u]:
      if e.dst == p: continue
      dfs(e.dst, u)
  dfs(0, -1)
  var t = g.initDoublingLowestCommonAncestor(0)
  let Q = nextInt()
  for _ in Q:
    let K = nextInt()
    var V = Seq[K: nextInt() - 1]
    var v = Seq[tuple[id, v:int]]
    for i in K:
      v.add (id[V[i]], V[i])
    v.sort()
    ans := 0
    for i in v.len:
      let j = (i + 1) mod v.len
      ans += t.dist(v[i].v, v[j].v)
    doAssert ans mod 2 == 0
    echo ans div 2
solve()
