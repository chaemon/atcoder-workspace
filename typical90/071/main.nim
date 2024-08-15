const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/scc

solveProc solve(N:int, M:int, K:int, A:seq[int], B:seq[int]):
  Pred A, B
  # 強連結成分があるとだめ
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
  var
    ans_all:seq[seq[int]]
    ans:seq[int]
    ended = false
    q = initDeque[int]()
  for u in N:
    if in_deg[u] == 0:
      q.addLast(u)
  proc f() =
    if ans.len == N:
      ans_all.add ans
      if ans_all.len == K:
        ended = true
      return
    let qlen = q.len
    for _ in qlen:
      let u = q.popFirst
      var vs, vs2:seq[int]
      for v in adj[u]:
        in_deg[v].dec
        if in_deg[v] == 0:
          q.addLast v
          vs.add v
      ans.add u + 1
      f()
      if ended: return
      for v in adj[u]:
        if in_deg[v] == 0:
          vs2.add q.pop_Last
        in_deg[v].inc
      discard ans.pop
      q.addLast(u)
  f()
  if ans.len < K:
    echo -1
  else:
    for ans in ans_all:
      echo ans.join(" ")
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
