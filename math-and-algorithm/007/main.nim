const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, Y:int):
  ans := 0
  for n in 1..N:
    if n mod X == 0 or n mod Y == 0: ans.inc
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  solve(N, X, Y)
else:
  discard

