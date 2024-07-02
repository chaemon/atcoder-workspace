const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/scc

solveProc solve(N:int, A:seq[int], B:seq[int]):
  Pred A, B
  var
    g = initSCCGraph(N)
    rev = Seq[N: seq[int]]
  for i in N:
    g.addEdge i, A[i]
    g.addEdge i, B[i]
    rev[A[i]].add i
    rev[B[i]].add i
  var
    groups = g.scc()
    vis = Seq[N: false]
    belongs = Seq[N: int]
    ans:seq[int]
  for i, s in groups:
    for v in s:
      belongs[v] = i
  for s in groups:
    # 各連結成分について
    # gの辺を外に出している頂点を1つ選び最後にやる
    var start = -1
    for v in s:
      if A[v] == v or B[v] == v: start = v; break
      if belongs[v] != belongs[A[v]]: start = v;break
      if belongs[v] != belongs[B[v]]: start = v;break
    if start == -1:
      echo -1;return
    var
      q = initDeque[int]()
      ans_sub:seq[int]
    q.addLast(start)
    while q.len > 0:
      var v = q.popFirst()
      if vis[v]: continue
      vis[v] = true
      ans_sub.add v
      for u in rev[v]: # u -> v
        q.addLast(u)
    ans_sub.reverse
    for v in ans_sub:
      ans.add v + 1
  echo ans.join("\n")
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
#}}}

