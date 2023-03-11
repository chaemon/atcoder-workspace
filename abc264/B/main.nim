const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(R:int, C:int):
  var
    R = R - 7
    C = C - 7
  if max(abs(R), abs(C)) mod 2 == 0:
    echo "white"
  else:
    echo "black"
  discard

when not defined(DO_TEST):
  var R = nextInt() - 1
  var C = nextInt() - 1
  solve(R, C)
else:
  discard

