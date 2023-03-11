const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int):
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

