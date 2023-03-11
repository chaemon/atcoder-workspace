const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int, H:int, M:int):
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var H = nextInt()
  var M = nextInt()
  solve(A, B, H, M)
else:
  discard

