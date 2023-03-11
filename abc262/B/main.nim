const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, U:seq[int], V:seq[int]):
  var A = Seq[N, N: false]
  for i in M:
    A[U[i]][V[i]] = true
    A[V[i]][U[i]] = true
  ans := 0
  for a in N:
    for b in a + 1 ..< N:
      for c in b + 1 ..< N:
        if A[a][b] and A[b][c] and A[c][a]: ans.inc
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  solve(N, M, U, V)
else:
  discard

