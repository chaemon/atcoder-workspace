when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int, B:int, X:int, Y:int):
  echo min(X div A, Y div B)
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var X = nextInt()
  var Y = nextInt()
  solve(A, B, X, Y)
else:
  discard

