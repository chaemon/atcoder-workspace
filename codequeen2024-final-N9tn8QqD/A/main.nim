when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(X:int):
  if X <= 10:
    echo 10
  elif X <= 15:
    echo 15
  else:
    echo 17
  discard

when not defined(DO_TEST):
  var X = nextInt()
  solve(X)
else:
  discard

