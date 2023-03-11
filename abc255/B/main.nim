const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, K:int, A:seq[int], X:seq[int], Y:seq[int]):
  proc dist(i, j:int):float =
    sqrt(((X[i] - X[j])^2 + (Y[i] - Y[j])^2).float)
  var ans = -float.inf
  for i in N:
    var R = float.inf
    for j in K:
      R.min=dist(i, A[j])
    ans.max= R
  echo ans
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt() - 1)
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, K, A, X, Y)
else:
  discard

