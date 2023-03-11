const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/graph/maxflow_lowerbound

solveProc solve(N:int, M:int, W:seq[int], L:seq[int]):
  let T = N * (N - 1) div 2
  var
    win = Seq[N, N: 0]
    ans = Seq[int]

  for i in M:
    win[W[i]][L[i]] = 1
    win[L[i]][W[i]] = -1
  for u in N:
    var win_count = Seq[N: 0]
    var g = initMaxFlowLowerBound[int](T + N + 2)
    let
      s = T + N
      t = s + 1
    var x = 0
    for a in N:
      for b in a + 1 ..< N:
        if win[a][b] == 0:
          if a == u:
            # a win
            win_count[u].inc
          elif b == u:
            # b win
            win_count[u].inc
          else:
            g.addEdge(s, x, 1, 1)
            g.addEdge(x, a + T, 0, 1)
            g.addEdge(x, b + T, 0, 1)
            x.inc
        elif win[a][b] == 1:
          win_count[a].inc
        elif win[a][b] == -1:
          win_count[b].inc
    var ok = true
    for v in N:
      if u == v: continue
      if win_count[v] >= win_count[u]: ok = false; break
      g.addEdge(v + T, t, 0, win_count[u] - 1 - win_count[v])
    if not ok: continue
    if g.canFLow(s, t): ans.add(u + 1)
  echo ans.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var W = newSeqWith(M, 0)
  var L = newSeqWith(M, 0)
  for i in 0..<M:
    W[i] = nextInt() - 1
    L[i] = nextInt() - 1
  solve(N, M, W, L)
else:
  discard
