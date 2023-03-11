const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/other/bitutils

import lib/graph/mincostflow_generalized
import lib/graph/mincostflow_lowerbound

# Failed to predict input format
solveProc solve(H, W, N:int, A, B, C:seq[int]):
  var g = initMinCostFlowLowerBound[int, int, GRAPHTYPE_POSITIVEEDGE](H + W + 2)
  let
    s = H + W
    t = s + 1
  for u in H:
    g.addEdge(s, u, 1, N, 0)
  for u in W:
    g.addEdge(u + H, t, 1, N, 0)
  for i in N:
    g.addEdge(A[i], B[i] + H, 0, 1, C[i])
#  discard g.can_flow(s, t)
  echo g.slope(s, t).get
#  echo g.max_flow(s, t).get[1]
  Naive:
    var ans = int.inf
    for b in 2^N:
      var
        lows = Seq[H:false]
        cols = Seq[W:false]
        s = 0
      for i in N:
        if b[i] == 1:
          lows[A[i]] = true
          cols[B[i]] = true
          s += C[i]
      if lows.count(true) < H or cols.count(true) < W: continue
      ans.min=s
    echo ans
  discard

when not DO_TEST:
  let H, W, N = nextInt()
  var A, B, C = Seq[N: int]
  for i in N:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    C[i] = nextInt()
  solve(H, W, N, A, B, C)
else:
  import random
  for ct in 100:
    debug ct
    let H, W = 3
    var N = 0
    var A, B, C = Seq[int]
    var lows = Seq[H: false]
    var cols = Seq[W: false]
    var listed = initSet[(int, int)]()
    while true:
      var Ai = random.rand(0..<H)
      var Bi = random.rand(0..<W)
      if (Ai, Bi) in listed:continue
      var Ci = random.rand(0..10)
      A.add Ai
      B.add Bi
      C.add Ci
      lows[Ai] = true
      cols[Bi] = true
      N.inc
      if lows.count(true) == H and cols.count(true) == W: break
    test(H, W, N, A, B, C)

