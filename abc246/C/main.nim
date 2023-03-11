const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, K:int, X:int, A:seq[int]):
  var
    K = K
    A = A
    s = 0
    S = A.sum
  for i in N:
    let
      q = A[i] div X
      r = A[i] mod X
    s += q
    A[i] = r
  if s > K:
    echo S - K * X
  elif K >= s + N:
    echo 0
  else:
    K -= s
    A.sort(SortOrder.Descending)
    echo A[K ..< A.len].sum
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, X, A)
else:
  discard

