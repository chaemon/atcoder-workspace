const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:int, B:int):
  discard

when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, A, B)
else:
  discard

