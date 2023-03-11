const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(X:int, Y:int, Z:int):
  if X + Y <= Z: echo 1
  else: echo 0
  return

when not DO_TEST:
  var X = nextInt()
  var Y = nextInt()
  var Z = nextInt()
  solve(X, Y, Z)
else:
  discard

