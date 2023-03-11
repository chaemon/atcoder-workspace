const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  let d = N mod 100
  if d == 0:
    echo "00"
  elif d < 10:
    echo "0", d
  else:
    echo d

  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

