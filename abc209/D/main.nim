const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import atcoder/extra/graph/graph_template
import atcoder/extra/tree/doubling_lowest_common_ancestor

# Failed to predict input format
block main:
  let N, Q = nextInt()
  var g = initGraph(N)
  for i in N - 1:
    let a, b = nextInt() - 1
    g.addBiEdge(a, b)
  var lca = g.initDoublingLowestCommonAncestor(0)
  for i in Q:
    let c, d = nextInt() - 1
    let e = lca.lca(c, d)
    let p = lca.dep[c] + lca.dep[d] - lca.dep[e] * 2
    if p mod 2 == 0:
      echo "Town"
    else:
      echo "Road"
  discard

