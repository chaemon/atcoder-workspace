const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int):
  var t:seq[int]
  if N mod 2 == 0:
    t = @[N div 2 - 1, N div 2]
  else:
    t = @[N div 2]
  if X in t:
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt() - 1
  solve(N, X)
else:
  discard

