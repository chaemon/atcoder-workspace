const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  if N < 42:
    echo fmt"AGC0{N:02d}"
  else:
    echo fmt"AGC0{N+1:02d}"
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

