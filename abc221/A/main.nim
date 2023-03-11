const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(A:int, B:int):
  echo 32^(A - B)
  return

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

