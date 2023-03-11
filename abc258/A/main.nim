const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(K:int):
  if K < 60:
    echo fmt"21:{K:02d}"
  else:
    echo fmt"22:{K - 60:02d}"
  discard

when not DO_TEST:
  var K = nextInt()
  solve(K)
else:
  discard

