when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(X:int, Y:int):
  if Y in X - 3 .. X + 2:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
else:
  discard

