const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int):
  echo gcd(A, B)
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

