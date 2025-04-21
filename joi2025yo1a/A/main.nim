when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int):
  echo A div 5
  discard

when not defined(DO_TEST):
  var A = nextInt()
  solve(A)
else:
  discard

