const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  var
    dist = Seq[N, N: int.inf]
    updated = Seq[N, N: false]
  for i in N: dist[i][i] = 0
  for i in M:
    dist[A[i]][B[i]] = C[i]
    dist[B[i]][A[i]] = C[i]
  for k in N:
    for i in N:
      if i == k: continue
      for j in N:
        if j == k: continue
        if dist[i][k] + dist[k][j] <= dist[i][j]:
          dist[i][j] = dist[i][k] + dist[k][j]
          updated[i][j] = true
  s := 0
  for i in N:
    for j in i + 1 ..< N:
      if not updated[i][j]:
        s.inc
  echo M - s
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A.pred, B.pred, C)
else:
  discard

