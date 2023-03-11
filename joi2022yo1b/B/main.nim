const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(A:int, B:int):
  var r = (A + B) mod 12
  if r == 0: r = 12
  echo r
  return

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

