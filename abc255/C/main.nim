const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(X:int, A:int, D:int, N:int):
  var
    m = A
    M = A + (N - 1) * D
  if m > M: swap m, M
  if X < m:
    echo m - X
  elif M < X:
    echo X - M
  else:
    var D = abs(D)
    if D == 0:
      echo abs(X - A)
    else:
      let m = ((X - A).floorDiv D) * D + A
      let M = ((X - A).ceilDiv D) * D + A
      echo min((X - m).abs, (X - M).abs)
  discard

when not DO_TEST:
  var X = nextInt()
  var A = nextInt()
  var D = nextInt()
  var N = nextInt()
  solve(X, A, D, N)
else:
  discard

