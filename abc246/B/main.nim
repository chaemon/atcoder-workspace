const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int):
  var
    A = float(A)
    B = float(B)
    d = sqrt(A^2 + B^2)
  A /= d
  B /= d
  echo A, " ", B
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

