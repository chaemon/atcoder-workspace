when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X_A:int, Y_A:int, X_B:int, Y_B:int, X_C:int, Y_C:int):
  discard

when not defined(DO_TEST):
  var X_A = nextInt()
  var Y_A = nextInt()
  var X_B = nextInt()
  var Y_B = nextInt()
  var X_C = nextInt()
  var Y_C = nextInt()
  solve(X_A, Y_A, X_B, Y_B, X_C, Y_C)
else:
  discard

