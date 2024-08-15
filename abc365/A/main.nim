when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(Y:int):
  if Y mod 4 != 0:
    echo 365
  elif Y mod 100 != 0:
    echo 366
  elif Y mod 400 != 0:
    echo 365
  else:
    echo 366
  discard

when not defined(DO_TEST):
  var Y = nextInt()
  solve(Y)
else:
  discard

