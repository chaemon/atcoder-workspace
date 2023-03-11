const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template
import heapqueue
import random

randomize()

solveProc solve(N:int, A:seq[int], B:seq[int], S:string):
  var
    g = initGraph(N)
    S = collect(newSeq): # 白: 1, 黒: 0
      for i in N:
        if S[i] == 'W': 1
        else: 0
  for i in N - 1:
    g.addBiEdge(A[i], B[i])
  var v = Seq[(int, int)]
  proc dfs(u, p:int):bool =
    for e in g[u]:
      if e.dst == p: continue
      discard dfs(e.dst, u)
    if p != -1:
      if S[u] == 1:
        S[p] = 1 - S[p]
        v.add((u, p))
      else:
        S[u] = 1 - S[u]
        v.add((p, u))
    else:
      if S[u] == 0:
        return false
      else: return true
  if not dfs(0, -1):
    echo -1;return
  var
    q = initHeapQueue[int]()
    inDeg = Seq[N:0]
    ans = Seq[int]
    adj = Seq[N:seq[int]]
  for (x, y) in v:
    inDeg[y].inc
    adj[x].add y
  for u in N:
    if inDeg[u] == 0: q.push u
  while q.len > 0:
    let u = q.pop()
    ans.add u + 1
    for v in adj[u]:
      inDeg[v].dec
      if inDeg[v] == 0: q.push v
  echo ans.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  var S = nextString()
  solve(N, A, B, S)
else:
  discard

