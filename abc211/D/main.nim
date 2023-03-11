const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/structure/red_black_tree
import lib/structure/randomized_binary_search_tree_with_parent

type SortedTree[Tree] = object
  End:Tree.Node
  tree:Tree

var v = SortedTree[RedBlackTree[int, void]]()
var v2 = SortedTree[RandomizedBinarySearchTree[int]]()


import lib/graph/graph_template
import lib/graph/dijkstra

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var g = initGraph(N)
  for i in M: g.addBiEdge(A[i], B[i])
  var dist = g.dijkstra(0)
  var v = Seq[tuple[d:int, u:int]]
  for u in N: v.add((dist[u], u))
  var dp = Seq[N: mint]
  v.sort
  dp[0] = 1
  for (d, u) in v:
    for e in g[u]:
      if d + e.weight == dist[e.dst]:
        dp[e.dst] += dp[u]
  echo dp[N - 1]
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, M, A, B)
#}}}

