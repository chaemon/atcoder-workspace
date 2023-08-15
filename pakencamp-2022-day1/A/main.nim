when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:int, Y:int):
  if X == 0 and Y == 0:
    echo 0
  elif X == 0 or Y == 0:
    echo 1
  else:
    echo 2
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
else:
  discard

