const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int, K:int):
  var
    c = 0
    A = A
  while true:
    if A >= B:
      echo c;break
    A *= K
    c.inc
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var K = nextInt()
  solve(A, B, K)
else:
  discard

