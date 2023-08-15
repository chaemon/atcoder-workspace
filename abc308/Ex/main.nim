when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  Pred A, B
  var
    cost = [N, N] @ int.inf
    adj = N @ seq[tuple[C:int, u:int]]
  for i in M:
    cost[A[i]][B[i]] = C[i]
    cost[B[i]][A[i]] = C[i]
    adj[A[i]].add((C[i], B[i]))
    adj[B[i]].add((C[i], A[i]))
  for u in N:
    adj[u].sort
  var ans0 = int.inf
  for u in N:
    for v in u + 1 ..< N:
      if cost[u][v] == int.inf: continue
      for w in v + 1 ..< N:
        if cost[u][w] == int.inf or cost[v][w] == int.inf: continue
        var ans = int.inf
        for i in adj[u].len:
          if adj[u][i].u == v or adj[u][i].u == w: continue
          ans.min=adj[u][i].C
          break
        for i in adj[v].len:
          if adj[u][i].u == w or adj[u][i].u == u: continue
          ans.min=adj[u][i].C
          break
        for i in adj[w].len:
          if adj[u][i].u == u or adj[u][i].u == v: continue
          ans.min=adj[u][i].C
          break
        if ans == int.inf: continue
        ans0.min= ans + cost[u][v] + cost[v][w] + cost[w][u]
  if ans0 == int.inf:
    echo -1
  else:
    echo ans0
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A, B, C)
else:
  discard

