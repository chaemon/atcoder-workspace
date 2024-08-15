when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(R:int):
  if R < 100:
    echo 100 - R
  elif R < 200:
    echo 200 - R
  elif R < 300:
    echo 300 - R
  discard

when not defined(DO_TEST):
  var R = nextInt()
  solve(R)
else:
  discard

