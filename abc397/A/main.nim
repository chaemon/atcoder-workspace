when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:float):
  if X >= 38.0:
    echo 1
  elif X >= 37.5:
    echo 2
  else:
    echo 3

when not defined(DO_TEST):
  var X = nextFloat()
  solve(X)
else:
  discard

