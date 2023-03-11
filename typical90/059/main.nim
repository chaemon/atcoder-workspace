const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

const MX = 10^5

import lib/graph/graph_template
import lib/other/bitutils

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, Q:int, X:seq[int], Y:seq[int], A:seq[int], B:seq[int]):
  Pred X, Y, A, B
  #var g = initDirectedGraph(N, X, Y)
  var E = Seq[(int, int)]
  for i in M:
    E.add (X[i], Y[i])
  E.sort
  var dp:array[100000, int]
  #dp := Seq[N: 0]
  for q in 0 ..< Q >> 64:
    dp.fill(0)
    let m = min(Q, q + 64)
    for i in q ..< m:
      dp[A[i]][i - q] = 1
    #for u in N:
    #  for e in g[u]:
    #    dp[e.dst].or=dp[u]
    for (X, Y) in E:
      dp[Y].or=dp[X]
    for i in q ..< m:
      if dp[B[i]][i - q] == 1:
        echo YES
      else:
        echo NO
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, Q, X, Y, A, B)

