when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int, T:int):
  echo 5 * A + T
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var T = nextInt()
  solve(A, T)
else:
  discard

