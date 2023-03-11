const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/scc

solveProc solve(N:int, M:int, K:int, A:seq[int], B:seq[int]):
  Pred A, B
  block:
    var g = initSccGraph(N)
    for i in M:
      g.addEdge(A[i], B[i])
    var s = g.scc
    for b in s:
      if b.len >= 2:
        echo -1
        return
  var
    adj = Seq[N: seq[int]]
    in_deg = Seq[N: 0]
  for i in M:
    adj[A[i]].add B[i]
    in_deg[B[i]].inc
  var in_deg0 = initSet[int]()
  for u in 0 ..< N:
    if in_deg[u] == 0:
      in_deg0.incl u
  var
    ans = Seq[seq[int]]
    a = Seq[int]
    found = false
  proc f(i = 0) =
    if found:
      return
    if i == N:
      ans.add a
      if ans.len == K:
        found = true
        return
    else:
      var
        c = 0
        nxt = Seq[int]
      for u in in_deg0:
        if c == 4:
          break
        nxt.add u
        c.inc
      for u in nxt:
        # uを加える
        in_deg0.excl u
        for v in adj[u]:
          in_deg[v].dec
          if in_deg[v] == 0:
            in_deg0.incl v
        a.add u
        f(i + 1)
        if found: return
        discard a.pop
        in_deg0.incl u
        for v in adj[u]:
          if in_deg[v] == 0:
            in_deg0.excl v
          in_deg[v].inc
    discard
  f(0)
  for i in ans.len:
    for j in ans[i].len:
      ans[i][j].inc
  for a in ans:
    echo a.join(" ")
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, K, A, B)
