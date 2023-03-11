const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int, C:int, X:int):
  if X <= A:
    echo 1
  elif X in A+1..B:
    echo C / (B - A)
  else:
    echo 0
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var X = nextInt()
  solve(A, B, C, X)
else:
  discard

