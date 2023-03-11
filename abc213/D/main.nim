const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var adj = newSeq[seq[int]](N)
  for i in N - 1:
    adj[A[i]].add(B[i])
    adj[B[i]].add(A[i])
  for i in N:
    adj[i].sort
  var vis = Seq[N: false]
  var ans = newSeq[int]()
  proc dfs(u, p:int) =
    ans.add(u + 1)
    vis[u] = true
    for v in adj[u]:
      if vis[v] or v == p: continue
      dfs(v, u)
      ans.add(u + 1)
  dfs(0, -1)
  echo ans.join(" ")

  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  solve(N, A, B)

