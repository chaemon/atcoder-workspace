const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(X:int, Y:int, N:int):
  ans := int.inf
  for i in 0..N:
    if i * 3 > N: break
    var j = N - i * 3
    ans.min=i * Y + X * j
  echo ans
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  var N = nextInt()
  solve(X, Y, N)
else:
  discard

