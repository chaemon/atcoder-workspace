when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:int):
  var
    a = 1
    N = 1
  while true:
    a *= N
    if X == a:
      echo N;return
    N.inc
  discard

when not defined(DO_TEST):
  var X = nextInt()
  solve(X)
else:
  discard

