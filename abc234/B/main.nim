const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve(N:int, x, y:seq[int]):
  ans := 0.0
  for i in N:
    for j in i + 1 ..< N:
      ans.max= sqrt(((x[i] - x[j])^2 + (y[i] - y[j])^2).float)
  echo ans
  discard

when not DO_TEST:
  let N = nextInt()
  let (x, y) = unzip(N, (nextInt(), nextInt()))
  solve(N, x, y)
else:
  discard

