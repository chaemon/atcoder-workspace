const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header



solveProc solve(N:int):
  if N <= 125: echo 4
  elif N <= 211: echo 6
  else: echo 8
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)

