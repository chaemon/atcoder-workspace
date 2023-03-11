const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, X:seq[int], Y:seq[int]):
  var ans = N * (N - 1) * (N - 2) div 6
  for i in 0..<N:
    for j in i+1..<N:
      for k in j+1..<N:
        let
          n0 = Y[i] - Y[j]
          d0 = X[i] - X[j]
          n1 = Y[j] - Y[k]
          d1 = X[j] - X[k]
        if n0 * d1 == n1 * d0:
          ans.dec
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
else:
  discard

