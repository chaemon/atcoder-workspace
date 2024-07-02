const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, x:seq[int], y:seq[int]):
  ans := float.inf
  for i in N:
    for j in i + 1 ..< N:
      ans.min=sqrt(float((x[i] - x[j])^2 + (y[i] - y[j])^2))
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
else:
  discard

